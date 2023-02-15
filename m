Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E266982F9
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjBOSNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjBOSNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:13:16 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34EA34303;
        Wed, 15 Feb 2023 10:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=3bn5296P2g1+5LsP4DHie0sJD8C69W5gQ+EHai/5viU=;
        t=1676484796; x=1677694396; b=bVEy587tUqxYJGoxan7HVxBHMylY1urWL6lA3B5lGvfZ86q
        4I6Wx4KVy2nqVpb7TMOOa6Xu/K/0+2Ko1o8t1kNGH+lW9oR4RnYMjpjn7r/ZM+Df81/RJCHdW1RFf
        6GujcAzyyogv5tHm/VlEiMKN+pvKdvymIK7DkTE5iew8GP1pikAmxIBGPu8clZrCioaAEDzccC4ok
        qI239GYTo2oNZqogkMAOLqYEkQeV3dK/xl9VH/MWwZgWcT7D4g3Zpokk7fOcSCsUj3QLAU0wNABiq
        HJU+RfrseWOam6mgG/3RajfmIqZORivgwkXtSfV/WuUK9A/2rmF+t+XaPvTwakrQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pSMHK-00DADs-0w;
        Wed, 15 Feb 2023 19:13:14 +0100
Message-ID: <1fb20d096fa4ddb2995d58ad30be560699f9eaf9.camel@sipsolutions.net>
Subject: Re: [PATCH v7 4/4] mac80211_hwsim: add PMSR report support via
 virtio
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jaewan Kim <jaewan@google.com>, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@android.com, adelva@google.com
Date:   Wed, 15 Feb 2023 19:13:13 +0100
In-Reply-To: <20230207085400.2232544-5-jaewan@google.com>
References: <20230207085400.2232544-1-jaewan@google.com>
         <20230207085400.2232544-5-jaewan@google.com>
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

On Tue, 2023-02-07 at 08:54 +0000, Jaewan Kim wrote:
> PMSR (a.k.a. peer measurement) is generalized measurement between two
> devices with Wi-Fi support. And currently FTM (a.k.a. fine time measureme=
nt
> or flight time measurement) is the one and only measurement.
>=20
> This change allows mac80211_hwsim to report PMSR result. The PMSR result
[...]
> This change adds HWSIM_CMD_REPORT_PMSR, HWSIM_ATTR_PMSR_RESULT. When
[...]
> To help receive the PMSR result detail, this CL also adds nla policies to

Generally you don't really need to talk about "this change" (or "this
CL"), just say it:

   Add the necessarily functionality to allow hwsim to report PMSR
   results. [...]

   To do that, add new hwsim netlink attributes ..._PMSR and
   ..._PMSR_RESULT.
  =20
(and I'd just remove the language about policies, that's obvious anyway)

> +	if (tb[NL80211_PMSR_PEER_ATTR_RESP]) {
> +		ret =3D mac80211_hwsim_parse_pmsr_resp(tb[NL80211_PMSR_PEER_ATTR_RESP]=
, result, info);

I didn't comment about long lines again, but this one stands out :)

> @@ -5758,7 +6118,7 @@ static struct genl_family hwsim_genl_family __ro_af=
ter_init =3D {
>  	.module =3D THIS_MODULE,
>  	.small_ops =3D hwsim_ops,
>  	.n_small_ops =3D ARRAY_SIZE(hwsim_ops),
> -	.resv_start_op =3D HWSIM_CMD_DEL_MAC_ADDR + 1,
> +	.resv_start_op =3D __HWSIM_CMD_MAX,

No. This was intentional that way. If this causes your new userspace
trouble, please adjust it. Clearly, it's new userspace implementation -
that's why the resv_start_op is set that way, to force stricter
validation on new ops that userspace cannot have implemented since they
didn't exist at the time we set this.

johannes
