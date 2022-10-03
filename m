Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFAA95F2B4F
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 09:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232202AbiJCH46 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 03:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbiJCH4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 03:56:09 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE6750714
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 00:33:21 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 69A0732005C1;
        Mon,  3 Oct 2022 03:19:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 03 Oct 2022 03:19:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1664781589; x=1664867989; bh=0X7sayyMLs4u8AAhyQUE6pwBWybq
        1g8do51vA28fWdg=; b=v2qATUsJolciytbFLjv8I8+SMfuMi3RtgowHH8T9dxBS
        UQEz9oi1ZxMg/kPW3Rw2SvZudP5cThzcoqUIlLzc0mN9OXx0CajFs42ls8Hdqudw
        yMET2Py77gzrF8/2YG7IPw6/URDo7dLXRBnJ5VTyj1Q9F1JDdyVc6e97n0wjaJjy
        mI/vKRn+/twt2ehm3aQFh38s8eljj43qrhemtk/yZsNDh41N0rEE4kYIy2CZ/V6j
        qYzSwjx5MLqirGPU3lggCQGZwd66GXrXY5BoTN6WoGk0c0gqwO5Q4JmT0O5cgO7Q
        R99gVaRauJQJJ9DFZWmxWNcDq3+XCEG+Z69Oibg5ig==
X-ME-Sender: <xms:FI06Ywh9keq7x4meNdcCywYZ147ZsE6w2Fs2x5p1l5ruhFfbra8e9g>
    <xme:FI06Y5CInREhEsEkI9BOGHV9ic50v9o04_etvW6jRiLs8wotQg-vwJ601gbLvMbGT
    URNEJt6f5Ut_DE>
X-ME-Received: <xmr:FI06Y4Hd5MQL1x_fat6JpnUbbPtkmDgLNua8vFJ7Q0UcYU-2txJAZcjdn9X_>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeehkedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:FI06YxSiQ8o2u3X5uma33qZZN_VpW2w4yYQox_jXtyq_oAUTmUR3DQ>
    <xmx:FI06Y9y-HeEhJaEfsvI7Sm6iUNpwxqyY8_ZebsVEbY9EzboiyE-YTQ>
    <xmx:FI06Y_6H2s43ZQhqFBOraHqe3SEXZ1ybnF07e4dvKvjVF-r2bATuOQ>
    <xmx:FY06Ywq3mXhyQQ9_dKY9r5vhKGuzTwgjaILRe7Ql3hjF0vyy2Lr6FA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 3 Oct 2022 03:19:48 -0400 (EDT)
Date:   Mon, 3 Oct 2022 10:19:45 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com
Subject: Re: [PATCH net-next v2 2/3] bnxt_en: add
 .get_module_eeprom_by_page() support
Message-ID: <YzqNEc6biKKrfugK@shredder>
References: <1664648831-7965-1-git-send-email-michael.chan@broadcom.com>
 <1664648831-7965-3-git-send-email-michael.chan@broadcom.com>
 <YzmvdxQpWviawxuj@shredder>
 <CAHLZf_sEB=dR2skpVuTD-r=SW4ZF9aOUKuNxibrjAKFe=v5+=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHLZf_sEB=dR2skpVuTD-r=SW4ZF9aOUKuNxibrjAKFe=v5+=Q@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 02, 2022 at 09:51:10PM +0530, Vikas Gupta wrote:
> On Sun, Oct 2, 2022 at 9:04 PM Ido Schimmel <idosch@idosch.org> wrote:
> >
> > On Sat, Oct 01, 2022 at 02:27:10PM -0400, Michael Chan wrote:
> > > +static int bnxt_get_module_eeprom_by_page(struct net_device *dev,
> > > +                                       const struct ethtool_module_eeprom *page_data,
> > > +                                       struct netlink_ext_ack *extack)
> > > +{
> > > +     struct bnxt *bp = netdev_priv(dev);
> > > +     int rc;
> > > +
> > > +     if (bp->link_info.module_status >
> > > +         PORT_PHY_QCFG_RESP_MODULE_STATUS_WARNINGMSG) {
> > > +             NL_SET_ERR_MSG_MOD(extack, "Phy status unknown");
> >
> > Can you make this more helpful to users? The comment above this check in
> > bnxt_get_module_info() suggests that it is possible:
> 
> Do you mean that we should elaborate something like
> NL_SET_ERR_MSG_MOD(extack, "Module may be not inserted or powered down
> or 10G Base-T");

Yes, but even then the exact error is unknown and you would need
something like drgn / kprobes to retrieve the specific module_state for
debug. You can do something like the following (in a separate function):

if (bp->link_info.module_status <=
    PORT_PHY_QCFG_RESP_MODULE_STATUS_WARNINGMSG)
        return 0;

switch (bp->link_info.module_status) {
case PORT_PHY_QCFG_RESP_MODULE_STATUS_PWRDOWN:
	NL_SET_ERR_MSG_MOD(extack, "Transceiver module is powering down");
	break;
case PORT_PHY_QCFG_RESP_MODULE_STATUS_NOTINSERTED:
	NL_SET_ERR_MSG_MOD(extack, "Transceiver module not inserted");
	break;
case PORT_PHY_QCFG_RESP_MODULE_STATUS_CURRENTFAULT:
	NL_SET_ERR_MSG_MOD(extack, "... something that explains what this means ...");
	break;
default:
	NL_SET_ERR_MSG_MOD(extack, "Unknown error");
	break;
}

return -EINVAL;

> 
> >
> > /* No point in going further if phy status indicates
> >  * module is not inserted or if it is powered down or
> >  * if it is of type 10GBase-T
> >  */
> > if (bp->link_info.module_status >
> >         PORT_PHY_QCFG_RESP_MODULE_STATUS_WARNINGMSG)
> >
> > > +             return -EIO;
> > > +     }
> > > +
> > > +     if (bp->hwrm_spec_code < 0x10202) {
> > > +             NL_SET_ERR_MSG_MOD(extack, "Unsupported hwrm spec");
> >
> > Likewise. As a user I do not know what "hwrm spec" means... Maybe:
> >
> > NL_SET_ERR_MSG_MOD(extack, "Firmware version too old");
> >
> >
> > > +             return -EOPNOTSUPP;
> > > +     }
> > > +
> > > +     if (page_data->bank && !(bp->phy_flags & BNXT_PHY_FL_BANK_SEL)) {
> > > +             NL_SET_ERR_MSG_MOD(extack, "Firmware not capable for bank selection");
> > > +             return -EOPNOTSUPP;
> >
> > What happens if you have an old firmware that does not support this
> > functionality and user space tries to dump page 10h from bank 1 of a
> > CMIS module that supports multiple banks?
> >
> > I wanted to say that you would see the wrong information (from bank 0)
> > because the legacy operations do not support banks and bank 0 is
> > assumed. However, because only pages 10h-ffh are banked, user space will
> > get an error from the following check in fallback_set_params():
> >
> > if (request->page)
> >         offset = request->page * ETH_MODULE_EEPROM_PAGE_LEN + offset;
> >
> > [...]
> >
> > if (offset >= modinfo->eeprom_len)
> >         return -EINVAL;
> >
> > I believe it makes sense to be more explicit about it and return an
> > error in fallback_set_params() in case bank is not 0. Please follow up
> > if the above analysis is correct.
> 
> So older firmware do not understand bank > 0 and hence it returns to
> EOPNOTSUPP, which goes to fallback_set_params() and fails for
> if (offset >= modinfo->eeprom_len)
>         return -EINVAL
> As we are not setting modinfo->eeprom_len for CMIS modules in get_module_eeprom.
> With the above said userspace gets EINVAL.
> Let me know if my understanding is correct?

Yes. Basically there is no point for ethtool to even try to invoke the
legacy operations when bank is not zero:

diff --git a/net/ethtool/eeprom.c b/net/ethtool/eeprom.c
index 1c94bb8ea03f..1d6a35c8b6f0 100644
--- a/net/ethtool/eeprom.c
+++ b/net/ethtool/eeprom.c
@@ -60,6 +60,9 @@ static int eeprom_fallback(struct eeprom_req_info *request,
 	u8 *data;
 	int err;
 
+	if (request->bank)
+		return -EINVAL;
+
 	modinfo.cmd = ETHTOOL_GMODULEINFO;
 	err = ethtool_get_module_info_call(dev, &modinfo);
 	if (err < 0)

Not sure how many will actually hit it. I expect drivers supporting
modules with banked pages to implement the new ethtool operation.
