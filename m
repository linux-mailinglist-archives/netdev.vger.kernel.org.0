Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624E3531355
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbiEWNny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 09:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236355AbiEWNnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 09:43:52 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B382C10B;
        Mon, 23 May 2022 06:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=Jf5WmGVZYC/08o+sn2rJm6Mnzt907p1woc86bVrXfkQ=;
        t=1653313429; x=1654523029; b=ngBCupVUF+nM44vdb+FFzkLuJqTJSHl39+d3HtC05OSC+g7
        SrckVkwAgYHhWd6D03Z73Jn0Et1mpb6dbIRQ4uguJX7vb1uDqu0WGJGzbRqSXofialCbWZjLei9Sj
        CuDgfiEc6HwmqXr5dg8Liug/GVYginDE7P3N0PU2Euq25efbb4xoxbWTeJXgqEcb2MatB6/i0uFgb
        Zm7ZzV+FjdBftXwsRF31oS+qoCU7c6DjqCAn5vedvgwvwTmIVuKFAusR4uHyyfvfQZrGUp9Ym7XjL
        yc3h4SNnn7+uDn1ROoWBdlAE2TCTHH6GeqJFejix7ToFSEm4HFTR6YjE5kWy/+YQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nt8LQ-002Qzm-Ac;
        Mon, 23 May 2022 15:43:36 +0200
Message-ID: <1e422d90e7e2d5a2c326de9c12aa70f8d3f82b96.camel@sipsolutions.net>
Subject: Re: [PATCH v3] mwifiex: fix sleep in atomic context bugs caused by
 dev_coredumpv
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Kalle Valo <kvalo@kernel.org>, duoming@zju.edu.cn
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rafael@kernel.org
Date:   Mon, 23 May 2022 15:43:34 +0200
In-Reply-To: <87r14kzdqz.fsf@kernel.org>
References: <20220523052810.24767-1-duoming@zju.edu.cn>
         <YosqUjCYioGh3kBW@kroah.com>
         <41a266af.2abb6.180efa8594d.Coremail.duoming@zju.edu.cn>
         <87r14kzdqz.fsf@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 (3.44.1-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-05-23 at 14:31 +0300, Kalle Valo wrote:
>=20
> In a way it would be nice to be able to call dev_coredump from atomic
> contexts, though I don't know how practical it actually is. Is there any
> other option? What about adding a gfp_t parameter to dev_set_name()? Or
> is there an alternative for dev_set_name() which can be called in atomic
> contexts?
>=20
> Johannes&Greg, any ideas?

If you need to, I guess you can collect the data into some area and then
provide it to devcoredump later? Not sure it's a good idea though since
collecting data can take a while.

johannes
