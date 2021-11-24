Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4A445B650
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 09:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241272AbhKXIPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 03:15:49 -0500
Received: from so254-9.mailgun.net ([198.61.254.9]:21242 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238955AbhKXIPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 03:15:49 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1637741560; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=qauOyx8RvBTgaUpTWSwFg+PXdJw4CHyCd0RZi44h1ZI=; b=GLOWh4Q32dlDKC+3ajC6tNxdDTPLr3tCTOQ4U2n2ILBp/YM+kiNCLzbm9knYheHATNS+SFlI
 5RSTGBpt98aI7ZmQkYfc/+RBhUYAjLl4a2rf9WU6IU7UGdTOIraC4W6T2VqJrlTBnRSIOqhM
 bqM38eVfQd88LNKS+2IVTExGGcc=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 619df3f76bacc185a5f276c3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 24 Nov 2021 08:12:39
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D6E2AC4360D; Wed, 24 Nov 2021 08:12:38 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 0F46DC4338F;
        Wed, 24 Nov 2021 08:12:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 0F46DC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Adam Borowski <kilobyte@angband.pl>
Cc:     Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: pcie: fix a warning / build failure
References: <20211124011754.22397-1-kilobyte@angband.pl>
Date:   Wed, 24 Nov 2021 10:12:35 +0200
In-Reply-To: <20211124011754.22397-1-kilobyte@angband.pl> (Adam Borowski's
        message of "Wed, 24 Nov 2021 02:17:54 +0100")
Message-ID: <87wnky55vw.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adam Borowski <kilobyte@angband.pl> writes:

> drivers/net/wireless/intel/iwlwifi/pcie/drv.c:
>         In function =E2=80=98iwl_pci_find_dev_info=E2=80=99:
> ./include/linux/kernel.h:46:25: error: overflow in conversion from
>         =E2=80=98long unsigned int=E2=80=99 to =E2=80=98int=E2=80=99 chan=
ges value from
>         =E2=80=9818446744073709551615=E2=80=99 to =E2=80=98-1=E2=80=99 [-=
Werror=3Doverflow]
>
> Signed-off-by: Adam Borowski <kilobyte@angband.pl>
> ---
> Another option would be to #ifdef away iwl_pci_find_dev_info().
>
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/=
wireless/intel/iwlwifi/pcie/drv.c
> index c574f041f096..81e8f2fc4982 100644
> --- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
> +++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
> @@ -1341,7 +1341,7 @@ iwl_pci_find_dev_info(u16 device, u16 subsystem_dev=
ice,
>  {
>  	int i;
>=20=20
> -	for (i =3D ARRAY_SIZE(iwl_dev_info_table) - 1; i >=3D 0; i--) {
> +	for (i =3D (int)ARRAY_SIZE(iwl_dev_info_table) - 1; i >=3D 0; i--) {
>  		const struct iwl_dev_info *dev_info =3D &iwl_dev_info_table[i];
>=20=20
>  		if (dev_info->device !=3D (u16)IWL_CFG_ANY &&

There's already fix for this:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers.git/=
commit/?id=3Dfe785f56ad5886c08d1cadd9e8b4e1ff6a1866f6

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
