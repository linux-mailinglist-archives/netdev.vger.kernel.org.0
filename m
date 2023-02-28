Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21996A5B4D
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 16:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjB1PGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 10:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjB1PGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 10:06:32 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8509211F6;
        Tue, 28 Feb 2023 07:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=OMOnOOvIDjn09cwF+3ZHnzsvQQ5bm1l+ehYbyj5+8x4=;
        t=1677596788; x=1678806388; b=WX0aktYfIPlIBdozqUYFMcNt8c7BwDUvCFGDXYuiB2mcdQn
        G3Vhk11GVU5Rf+sZrpTSNMs1o+Dy+Ap+/7GkgfT1a6soTtElENJVEfdD7jObmIxGkiYDkOiZf/bR5
        u6cHRDuPQi9M2CbVclYbBfOQH6rLCveUzzhAxXw5rr5o5sehZ7nCzqkBCBan51tI4GXk6sueDMGtP
        Tien78JSXlBwu4oeiz/OPNvY1hmiIOIiSg4dYPD1uIL+OHUqYQ1slRU1MDzTl4cvv12KqrlWEeTQf
        9WwT865CX+/hdo0QlHa4vDwrLfpq26JZHM37Ehc7pYCV7AbVuQrhaQBfuiJrMgFw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pX1Ye-0081LS-2U;
        Tue, 28 Feb 2023 16:06:24 +0100
Message-ID: <801c31cf13c209c97ef56c36efd7b16b37347580.camel@sipsolutions.net>
Subject: Re: [PATCH v7 2/4] mac80211_hwsim: add PMSR request support via
 virtio
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jaewan Kim <jaewan@google.com>
Cc:     gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com, adelva@google.com
Date:   Tue, 28 Feb 2023 16:06:23 +0100
In-Reply-To: <CABZjns4r_CJ-paj1FQ-SMFJMQW7rkXnvx5w98zYRgf6UQSnfkw@mail.gmail.com>
References: <20230207085400.2232544-1-jaewan@google.com>
         <20230207085400.2232544-3-jaewan@google.com>
         <fbe6f8eb820b29f0cc932a63ad84253d0cef93c3.camel@sipsolutions.net>
         <CABZjns4r_CJ-paj1FQ-SMFJMQW7rkXnvx5w98zYRgf6UQSnfkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
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

On Fri, 2023-02-24 at 00:38 +0900, Jaewan Kim wrote:
>=20
> >=20
> > > +int cfg80211_send_chandef(struct sk_buff *msg, const struct cfg80211=
_chan_def *chandef);
> >=20
> > I think it'd be better if you exported it as nl80211_..., since it
> > really is just a netlink thing, not cfg80211 functionality.
>=20
> Sorry about the late response but could you elaborate to me in more
> detail on this?
> Where header file would be the good place if it's exporting it as nl80211=
_...?

Oh, same header file, just with a different function name prefix.
nl80211 is part of cfg80211 anyway, but having it nl80211_ will make it
clearer (IMHO) that it does stuff related to netlink.

> net/wireless/nl80211.h seems like your suggestion, but I can't find
> how to include this from mac80211_hwsim.c.

That's just an internal header.

Leave it here, but I think we could rename it.

johannes
