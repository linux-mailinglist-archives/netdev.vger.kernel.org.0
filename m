Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E95DA5FDE10
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 18:16:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiJMQQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 12:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiJMQQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 12:16:51 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BAA5CC800
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 09:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=JGm9mzZQhE3VJZgfbLhPFFgZWxxKCb9F/DYYO9NIY5c=;
        t=1665677811; x=1666887411; b=SVvJkPkPhzr6jBzohcgcQZxFHEJmR6/CeLVt84kVtxRfpuL
        d9wn+tiFDdAIz2PXjnEl0jPlDWVwzA74NWjbSYihbSztjkhe7qNBMuJZmBEhp4jBWPGe8OEfidR/v
        nFGQShK8873MmsyRCYyHQOuASy/zPUtD4/TOqqz3AonPJoHHaz+53GT5EJ0vzp3v92UoH0PFhlHGk
        qxHt1yOb2Bl8uiknuBAGSBCzEbRFI5BqPxz+PkWPpCq98+G6Uf76Y+dOLcetsZWwE2hOhKrMKlELB
        Mw7DNC8vtlkh4B/FGS5zwVGzWtjMwXnK3sY6EsHP4sJ8n3RZEC7aUw9xQcPdWOtQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oj0t6-005kSf-1h;
        Thu, 13 Oct 2022 18:16:48 +0200
Message-ID: <873a9e2e933cd811a72f9a06cc97e9f014bc94cd.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v2 net-next 1/3] netlink: add support for formatted
 extack messages
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, edward.cree@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com, marcelo.leitner@gmail.com,
        Edward Cree <ecree.xilinx@gmail.com>
Date:   Thu, 13 Oct 2022 18:16:47 +0200
In-Reply-To: <20221013082913.0719721e@kernel.org>
References: <cover.1665567166.git.ecree.xilinx@gmail.com>
         <26c2cf2e699de83905e2c21491b71af0e34d00d8.1665567166.git.ecree.xilinx@gmail.com>
         <20221013082913.0719721e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-10-13 at 08:29 -0700, Jakub Kicinski wrote:
>=20
>    I'd do:
>=20
>    pr(extack formatting overflow $__FILE__:$__func__:$__LINE__ $needed_le=
n)
>   =20
>    (I think splicing the "trunced extack:" with fmt will result
>     in the format string getting stored in .ro twice?)
>=20

If you worry about the strings (and sizes) then you probably shouldn't
advocate always having __FILE__ and __func__ ;-)

FWIW, my argument earlier was that if we have the truncated string

 a) it lets you recover better in a live system
 b) the message ought to be enough to figure out where the issue is, and
    if the message isn't unique you probably have the problem twice too

But yeah, I'm with "take it or leave it", it all doesn't matter that
much.

johannes
