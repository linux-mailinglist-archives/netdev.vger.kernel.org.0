Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA955F23E3
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 17:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiJBPeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 11:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiJBPeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 11:34:24 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509B83EA79
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 08:34:22 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 3FAB832008FC;
        Sun,  2 Oct 2022 11:34:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 02 Oct 2022 11:34:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1664724859; x=1664811259; bh=zv6N/9fKcAoQpoF+TLHwOInzpC5O
        R6ko6AzcbPfEAAw=; b=xFL4eAem6SuPOwyCDZlm/rlZ8vE2sUfI61x2bw5/cLAx
        Jk6QSHdsXtko6IhB3kMjnuL0+MfbfizYiQheUx9ROiup3az9sRmwXogPkXVztnMF
        dhgOo8LDP9cuBkddoQHOWDKCxByFWIRuegoD1j1FQ3sZ7cEmQDydpKuVd32Tc2PI
        Tg1fKmEA6crI5mZA+EH+WmrjL9Sq5s0v91NXPWJxdsGQ5ClIsvFmS+0oE1nbKjdU
        /UOLnPQqo+bjmley02nCv45spEzQpYhVb9twRmFzeBqIDhD7yotUERNhd9sa8ep8
        BxwKg03S2AXUSWhF8JFKrAjJpegIChItPCFrcgx6GQ==
X-ME-Sender: <xms:e685YyvupOjJGuYlM7NsqxdBaurbpDW8lSmtGJs6JaT4N-A6fkZUyg>
    <xme:e685Y3cmzl09XdWtm2r610z_LRGidJHPJL2JAM1KoMNPTF_owvbLec5yVgiTt8XPS
    HKvAMYi95kHiYA>
X-ME-Received: <xmr:e685Y9yiacYmTac3ySD1vl_emx14Mf-XjR-9y0Rgmx1cbOY_y6WCrs-HV4rJ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeehjedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepfeefueegheehleelgeehjefgieeltdeuteekkeefheejudffleefgfeludeh
    hfejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:e685Y9Nr_5JnLJRstVY0DkPZQVJG5dhZhtKWVsitEcaSyQGuVKtAQg>
    <xmx:e685Yy8_aK4wXxQ-EVha-bJTwOKjXbCcevrTCP2FiLVX0SlhVnSlsQ>
    <xmx:e685Y1W9YW3lTz-BO4TULxA-LsxRp7dkPm298dDU88E8BFALWoU2XQ>
    <xmx:e685Y5mEPmKjmqeujigQPNWDfO-wFG0HV4c_L-I3mbjsWvqFkNNx7Q>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 2 Oct 2022 11:34:18 -0400 (EDT)
Date:   Sun, 2 Oct 2022 18:34:15 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, gospo@broadcom.com,
        vikas.gupta@broadcom.com
Subject: Re: [PATCH net-next v2 2/3] bnxt_en: add
 .get_module_eeprom_by_page() support
Message-ID: <YzmvdxQpWviawxuj@shredder>
References: <1664648831-7965-1-git-send-email-michael.chan@broadcom.com>
 <1664648831-7965-3-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1664648831-7965-3-git-send-email-michael.chan@broadcom.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 01, 2022 at 02:27:10PM -0400, Michael Chan wrote:
> +static int bnxt_get_module_eeprom_by_page(struct net_device *dev,
> +					  const struct ethtool_module_eeprom *page_data,
> +					  struct netlink_ext_ack *extack)
> +{
> +	struct bnxt *bp = netdev_priv(dev);
> +	int rc;
> +
> +	if (bp->link_info.module_status >
> +	    PORT_PHY_QCFG_RESP_MODULE_STATUS_WARNINGMSG) {
> +		NL_SET_ERR_MSG_MOD(extack, "Phy status unknown");

Can you make this more helpful to users? The comment above this check in
bnxt_get_module_info() suggests that it is possible:

/* No point in going further if phy status indicates
 * module is not inserted or if it is powered down or
 * if it is of type 10GBase-T
 */
if (bp->link_info.module_status >
	PORT_PHY_QCFG_RESP_MODULE_STATUS_WARNINGMSG)

> +		return -EIO;
> +	}
> +
> +	if (bp->hwrm_spec_code < 0x10202) {
> +		NL_SET_ERR_MSG_MOD(extack, "Unsupported hwrm spec");

Likewise. As a user I do not know what "hwrm spec" means... Maybe:

NL_SET_ERR_MSG_MOD(extack, "Firmware version too old");


> +		return -EOPNOTSUPP;
> +	}
> +
> +	if (page_data->bank && !(bp->phy_flags & BNXT_PHY_FL_BANK_SEL)) {
> +		NL_SET_ERR_MSG_MOD(extack, "Firmware not capable for bank selection");
> +		return -EOPNOTSUPP;

What happens if you have an old firmware that does not support this
functionality and user space tries to dump page 10h from bank 1 of a
CMIS module that supports multiple banks?

I wanted to say that you would see the wrong information (from bank 0)
because the legacy operations do not support banks and bank 0 is
assumed. However, because only pages 10h-ffh are banked, user space will
get an error from the following check in fallback_set_params():

if (request->page)
	offset = request->page * ETH_MODULE_EEPROM_PAGE_LEN + offset;

[...]

if (offset >= modinfo->eeprom_len)
	return -EINVAL;

I believe it makes sense to be more explicit about it and return an
error in fallback_set_params() in case bank is not 0. Please follow up
if the above analysis is correct.

> +	}
> +
> +	rc = bnxt_read_sfp_module_eeprom_info(bp, page_data->i2c_address << 1,

I was wondering why the shift is needed, but I see that in other places
you are passing 0xA0 and 0xA2 instead of 0x50 and 0x51, so it is OK.

> +					      page_data->page, page_data->bank,
> +					      page_data->offset,
> +					      page_data->length,
> +					      page_data->data);
> +	if (rc) {
> +		NL_SET_ERR_MSG_MOD(extack, "Module`s eeprom read failed");
> +		return rc;
> +	}
> +	return page_data->length;
> +}

Looks good otherwise.

Thanks
