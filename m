Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDC55ED940
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 11:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233745AbiI1Jfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 05:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbiI1Jec (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 05:34:32 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724ABE99A7
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 02:34:12 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 518515C0105;
        Wed, 28 Sep 2022 05:34:10 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Wed, 28 Sep 2022 05:34:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1664357650; x=1664444050; bh=qrq7xQF79rzW3fxDmqZb2nk6+eJl
        4b8G0nLZAwcQa04=; b=NdP/Y7SUrLdonm5WrGYaJ+3KtNrNrCH+HeXL6mPIK2Fj
        l8wHe1RAoGBdHc/du6103NQ7arvTe/QKzXQIQkAOmVbmULZZxNCbZKsa0+VE7Y8U
        5jvarbRotClE0pPYsDnkUgCohkj6jbLWIZ/chEpr7GBZ/zdEA6aGau6A4CBqMcEY
        faZxNQwILZK10LhOh0LswK26UGmK/soUbfW/XnuQrvBPF4qKJ7W8D+K+i+JuSwH3
        wmiH3M2l8pEUWlnd3ITkAz26HV1nRCRa+eQLRTKGYlVSpcDlWsXsNpZca62PKdll
        Qsdxy3Ar/HnvJTYQ48n7iuzhjPyb4O35j73RF07Oig==
X-ME-Sender: <xms:EhU0Y6qcY34TvteFfJe_aRbHqD8on2fcFNCG8k9Xw46hbnVq5KCp6w>
    <xme:EhU0Y4qM2G_3B0vQhO05mnEMIOYO79PK3DGF5NDWdU1hH4JSqMWxMrfUHK9LZRUGQ
    PCTow6r823kG74>
X-ME-Received: <xmr:EhU0Y_MqEGByCZP5DaTNWy-5tkbKqnAD1qkIzOh-0AHpJcKkOEc0hwWA7juxjdkF6GXC8Nd84zYfOo3mzyzMNBiwHxIVyg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeegkedgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhephefhtdejvdeiffefudduvdffgeetieeigeeugfduffdvffdtfeehieejtdfh
    jeeknecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:EhU0Y54HYARrkDC833IicNLODVVWEDr4Tv3GqwBpbXstOg2F072rHQ>
    <xmx:EhU0Y572pmnx8r72fw-BJhHZWJ60su-BzSPZ6pW5nylP7wt-T4cnRw>
    <xmx:EhU0Y5iRN9wwslOpGeVxfzmJyS8wsOZYW-w0mQDnBh0qYZWZvEp6dA>
    <xmx:EhU0Y3RGuRBc-UwJed6Auu0i3dCpN4MgaD-SSK4CIeEc3Gac83ehYQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Sep 2022 05:34:09 -0400 (EDT)
Date:   Wed, 28 Sep 2022 12:34:05 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, gospo@broadcom.com,
        vikas.gupta@broadcom.com
Subject: Re: [PATCH net-next 5/6] bnxt_en: add .get_module_eeprom_by_page()
 support
Message-ID: <YzQVDXDTRnM/Oz4z@shredder>
References: <1664326724-1415-1-git-send-email-michael.chan@broadcom.com>
 <1664326724-1415-6-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1664326724-1415-6-git-send-email-michael.chan@broadcom.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 08:58:43PM -0400, Michael Chan wrote:
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> index 0209f7caf490..03b1a0301a46 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> @@ -2207,6 +2207,15 @@ struct bnxt {
>  #define SFF_MODULE_ID_QSFP			0xc
>  #define SFF_MODULE_ID_QSFP_PLUS			0xd
>  #define SFF_MODULE_ID_QSFP28			0x11
> +#define SFF_MODULE_ID_QSFP_DD			0x18
> +#define SFF_MODULE_ID_DSFP			0x1b
> +#define SFF_MODULE_ID_QSFP_PLUS_CMIS		0x1e
> +
> +#define BNXT_SFF_MODULE_BANK_SUPPORTED(module_id)	\
> +	((module_id) == SFF_MODULE_ID_QSFP_DD ||	\
> +	 (module_id) == SFF_MODULE_ID_QSFP28 ||		\
> +	 (module_id) == SFF_MODULE_ID_QSFP_PLUS_CMIS)

I suggest dropping this check unless you have a good reason to keep it.
There are other modules out there that implement CMIS (e.g., OSFP) and
given bnxt implements ethtool_ops::get_module_eeprom_by_page, it should
be able to support them without kernel changes.

See:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=970adfb76095fa719778d70a6b86030d2feb88dd

The problem there was more severe because the driver returned '-EINVAL'
instead of '-EOPNOTSUPP'.

> +
>  #define SFF8636_FLATMEM_OFFSET			0x2
>  #define SFF8636_FLATMEM_MASK			0x4
>  #define SFF8636_OPT_PAGES_OFFSET		0xc3
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index 379afa670494..2b18af95aacb 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -3363,6 +3363,60 @@ static int bnxt_get_module_eeprom(struct net_device *dev,
>  	return 0;
>  }
>  
> +static int bnxt_get_module_eeprom_by_page(struct net_device *dev,
> +					  const struct ethtool_module_eeprom *page_data,
> +					  struct netlink_ext_ack *extack)
> +{
> +	struct bnxt *bp = netdev_priv(dev);
> +	u16 length = page_data->length;
> +	u8 *data = page_data->data;
> +	u8 page = page_data->page;
> +	u8 bank = page_data->bank;
> +	u16 bytes_copied = 0;
> +	u8 module_id;
> +	int rc;
> +
> +	/* Return -EOPNOTSUPP to fallback on .get_module_eeprom */
> +	if (!(bp->phy_flags & BNXT_PHY_FL_BANK_SEL))
> +		return -EOPNOTSUPP;

Maybe:

if (bank && !(bp->phy_flags & BNXT_PHY_FL_BANK_SEL)) {
	// extack
	return -EINVAL;
}

This should allow you to get rid of patch #2.

> +
> +	rc = bnxt_module_status_check(bp);
> +	if (rc)
> +		return rc;

You can add extack here. I see that this function always returns
'-EOPNOTSUPP' in case of errors, even when it does not make sense to
fallback to ethtool_ops::get_module_eeprom.

> +
> +	rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0, 0, false,
> +					      0, 1, &module_id);
> +	if (rc)
> +		return rc;
> +
> +	if (!BNXT_SFF_MODULE_BANK_SUPPORTED(module_id))
> +		return -EOPNOTSUPP;

I believe this hunk can be removed given the first comment.

> +
> +	while (length > 0) {
> +		u16 chunk = ETH_MODULE_EEPROM_PAGE_LEN;
> +		int rc;
> +
> +		/* Do not access more than required */
> +		if (length < ETH_MODULE_EEPROM_PAGE_LEN)
> +			chunk = length;
> +
> +		rc = bnxt_read_sfp_module_eeprom_info(bp,
> +						      I2C_DEV_ADDR_A0,

page_data->i2c_address

> +						      page, bank,
> +						      true, page_data->offset,
> +						      chunk, data);
> +		if (rc)

You can add a meaningful extack here according to the return code.

> +			return rc;
> +
> +		data += chunk;
> +		length -= chunk;
> +		bytes_copied += chunk;
> +		page++;
> +	}

I'm not sure why the loop is required? It seems
bnxt_read_sfp_module_eeprom_info() is able to read
'ETH_MODULE_EEPROM_PAGE_LEN' bytes at once, which is the maximum:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ethtool/eeprom.c#n234

> +
> +	return bytes_copied;
> +}
> +
>  static int bnxt_nway_reset(struct net_device *dev)
>  {
>  	int rc = 0;
> @@ -4172,6 +4226,7 @@ const struct ethtool_ops bnxt_ethtool_ops = {
>  	.set_eee		= bnxt_set_eee,
>  	.get_module_info	= bnxt_get_module_info,
>  	.get_module_eeprom	= bnxt_get_module_eeprom,
> +	.get_module_eeprom_by_page = bnxt_get_module_eeprom_by_page,
>  	.nway_reset		= bnxt_nway_reset,
>  	.set_phys_id		= bnxt_set_phys_id,
>  	.self_test		= bnxt_self_test,
> -- 
> 2.18.1
> 
