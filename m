Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A50C60D50F
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 21:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbiJYT5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 15:57:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232334AbiJYT5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 15:57:07 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 202EE5B122;
        Tue, 25 Oct 2022 12:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=25qw2GDUdBjXNVN2llD3TiYv8fWu8bz2tfuYAi1Rx70=;
        t=1666727826; x=1667937426; b=K9qM46o25/YYEqGSqIIsxc2LOF1atygdWZtg2cw2yN07eod
        +pS3FRAbPRb5ITMtiClVp6kchZmkBBCQYB42SLdZ8iLRMN4bHKh3t/WiCMpk3wscsbYhxAfYhulho
        NZG9lQ7FpJQ4RHUvN5d4juP4Q2zLs5STqpSnZ7q5WIvgKhbFG33q6MTrQCEyjvTZYeMm3h5KUBa75
        0qvvcO/8dr13sA4bSo2WEEM8nWktbFUVTyraapzn6qCh2MVpaLTeBhWSwgApE71WsE/wQJoDfv/1A
        tK3aVpZ4GlloWm/Z7MU3S1XsWdVTBUIveJtqmSXFDEaTYfVoveyNK0aamyWS9/Kg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1onQ2B-00GR5Q-1J;
        Tue, 25 Oct 2022 21:56:23 +0200
Message-ID: <c27de92c10d05891bc804fe0b955c7428ec534dd.camel@sipsolutions.net>
Subject: Re: [RFC PATCH 0/2] Branch Target Injection (BTI) gadget in minstrel
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     scott.d.constable@intel.com, daniel.sneddon@linux.intel.com,
        Jakub Kicinski <kuba@kernel.org>, dave.hansen@intel.com,
        Paolo Abeni <pabeni@redhat.com>,
        antonio.gomez.iglesias@linux.intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, gregkh@linuxfoundation.org, netdev@vger.kernel.org
Date:   Tue, 25 Oct 2022 21:56:21 +0200
In-Reply-To: <20221025193845.z7obsqotxi2yiwli@desk>
References: <cover.1666651511.git.pawan.kumar.gupta@linux.intel.com>
         <Y1fDiJtxTe8mtBF8@hirez.programming.kicks-ass.net>
         <20221025193845.z7obsqotxi2yiwli@desk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-10-25 at 12:38 -0700, Pawan Gupta wrote:
>=20
> > And how is sprinking random LFENCEs around better than running with
> > spectre_v2=3Deibrs,retpoline which is the current recommended mitigatio=
n
> > against all this IIRC (or even eibrs,lfence for lesser values of
> > paranoia).
>=20
> Its a trade-off between performance and spot fixing (hopefully handful
> of) gadgets. Even the gadget in question here is not demonstrated to be
> exploitable. If this scenario changes, polluting the kernel all over is
> definitely not the right approach.
>=20
Btw, now I'm wondering - you were detecting these with the compiler
based something, could there be a compiler pass to insert appropriate
things, perhaps as a gcc plugin or something?

Now honestly I have no idea if it's feasible, but since you're detecting
it that way, and presumably then we'd have to maintain the detection and
run it regularly to make sure that (a) things didn't bitrot and the
gadget is still there, and (b) no new places show up ... perhaps the
better way would be to combine both?

johannes
