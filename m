Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D94675EEF11
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235026AbiI2HcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:32:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234900AbiI2HcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:32:23 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D426137937
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:32:21 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 82FE75C00DA;
        Thu, 29 Sep 2022 03:32:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 29 Sep 2022 03:32:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1664436739; x=1664523139; bh=6ml2NsvR8Ahwy9CSVAbn3mTEO3IC
        rcfBv35oArsnigs=; b=KRBTPachGymKtHKLYK8PoPSQiLSCX3WnEqK0AHtC5MTr
        sTXmstyIlleY/o5aeWIzagcZrTL7Sal+btbWPhTdAr8rdyaDpk28JykSZmDe3fVI
        lWplj7CxT2v41ZxsM1YtkiY8W59cqT9R5Do6T5nvZ+dV+mV9OCbp2OboLFLm+zUd
        Bt3LUhRpWsRvoP+D/I8u6/3/hi4Mn7elC//m0YmNr15bgqS77B7tbPMpTJm+lJGq
        VBQ7XDCGoU5YwkzXg2Yh/yWIU8BdOb7tSpZrFwdM+w018nIeqrKdGQfy/3tecNiS
        Rv7RLtY74B4Li5+M6OtetiKCP4khZkCad4Zy1VN7uA==
X-ME-Sender: <xms:A0o1Yy_P159VaOO2ohUH3jEd-Hdf6-rVRoU3yuIAwJjkaUGxjZKU2g>
    <xme:A0o1YyuNUfzlHLXxCJYJC9QAxbK3BUIJdFUsZLqU5Ajbm85lp5AXUniwicsAr5tXK
    oVJKLuWEXs8wZQ>
X-ME-Received: <xmr:A0o1Y4AVkhgYSBbJJabeHkKnzfwi3szdBLkKa6h0-AARWeINCUKS6bQY8n6wAMD8DJ3gLsX9ta8Ts7P1x_-82q9wpY4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeegledguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpeehhfdtjedviefffeduuddvffegteeiieeguefgudffvdfftdefheeijedt
    hfejkeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhr
    gh
X-ME-Proxy: <xmx:A0o1Y6eTZ8wlmckxk9taRGQpQsWLg-RLeoh6cuJh8TtbZTX1bfA7eA>
    <xmx:A0o1Y3Os-UIZ4JhdirM8nlSBtTtlP487ZA-XcL6MkIgH-sr2FAba-g>
    <xmx:A0o1Y0lbKApQXBoe4ZZneDHb7pYw4nSCA5T37hlRUF-mYjKBZ7nT-A>
    <xmx:A0o1Yy1k6hVn5a-20vqvav_Yr8sc5zNgxyt7rdhoIGqPHUioKPbZuA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 29 Sep 2022 03:32:18 -0400 (EDT)
Date:   Thu, 29 Sep 2022 10:32:14 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, gospo@broadcom.com
Subject: Re: [PATCH net-next 5/6] bnxt_en: add .get_module_eeprom_by_page()
 support
Message-ID: <YzVJ/vKJugoz15yV@shredder>
References: <1664326724-1415-1-git-send-email-michael.chan@broadcom.com>
 <1664326724-1415-6-git-send-email-michael.chan@broadcom.com>
 <YzQVDXDTRnM/Oz4z@shredder>
 <CAHLZf_s3en3Lgjxu6u1ii254vow-0CkHWk0j3jhBzY2MHCcLUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHLZf_s3en3Lgjxu6u1ii254vow-0CkHWk0j3jhBzY2MHCcLUw@mail.gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 11:05:15AM +0530, Vikas Gupta wrote:
> On Wed, Sep 28, 2022 at 3:04 PM Ido Schimmel <idosch@idosch.org> wrote:
> >
> > On Tue, Sep 27, 2022 at 08:58:43PM -0400, Michael Chan wrote:
> > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> > > index 0209f7caf490..03b1a0301a46 100644
> > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> > > @@ -2207,6 +2207,15 @@ struct bnxt {
> > >  #define SFF_MODULE_ID_QSFP                   0xc
> > >  #define SFF_MODULE_ID_QSFP_PLUS                      0xd
> > >  #define SFF_MODULE_ID_QSFP28                 0x11
> > > +#define SFF_MODULE_ID_QSFP_DD                        0x18
> > > +#define SFF_MODULE_ID_DSFP                   0x1b

Does not seem to be used.

> > > +#define SFF_MODULE_ID_QSFP_PLUS_CMIS         0x1e
> > > +
> > > +#define BNXT_SFF_MODULE_BANK_SUPPORTED(module_id)    \
> > > +     ((module_id) == SFF_MODULE_ID_QSFP_DD ||        \
> > > +      (module_id) == SFF_MODULE_ID_QSFP28 ||         \

Did you mean DSFP here? QSFP28 is SFF-8636, not CMIS.

> > > +      (module_id) == SFF_MODULE_ID_QSFP_PLUS_CMIS)
> >
> > I suggest dropping this check unless you have a good reason to keep it.
> > There are other modules out there that implement CMIS (e.g., OSFP) and
> > given bnxt implements ethtool_ops::get_module_eeprom_by_page, it should
> > be able to support them without kernel changes.
> >
> > See:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=970adfb76095fa719778d70a6b86030d2feb88dd
> >
> > The problem there was more severe because the driver returned '-EINVAL'
> > instead of '-EOPNOTSUPP'.
> >
> We want to fallback on get_module_eeprom callback in case modules do
> not implement CMIS and we pass the bank parameter accordingly to the
> firmware.

ethtool_ops::get_module_eeprom_by_page has nothing to do with CMIS. It
is a generic operation to retrieve module EEPROM data based on a "3D
address": bank, page and offset.

The driving motivation behind it was CMIS modules, but it must be
implemented in a way that it can retrieve information from modules that
implement a different management interface such as SFF-8636.

Let's say that tomorrow a user asks to retrieve pages 20h-21h from a
QSFP module that implements SFF-8636, how will you support it? You can't
extend the legacy ethtool::get_module_eeprom operation and your current
implementation of ethtool_ops::get_module_eeprom_by_page has an
artificial limitation to support only CMIS modules.

By making sure that your implementation is generic as possible you will
be able to support all possible requests and will not need to
continuously patch the kernel (and users will not need to continuously
upgrade).

> 
> > > +
> > >  #define SFF8636_FLATMEM_OFFSET                       0x2
> > >  #define SFF8636_FLATMEM_MASK                 0x4
> > >  #define SFF8636_OPT_PAGES_OFFSET             0xc3
> > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > index 379afa670494..2b18af95aacb 100644
> > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > @@ -3363,6 +3363,60 @@ static int bnxt_get_module_eeprom(struct net_device *dev,
> > >       return 0;
> > >  }
> > >
> > > +static int bnxt_get_module_eeprom_by_page(struct net_device *dev,
> > > +                                       const struct ethtool_module_eeprom *page_data,
> > > +                                       struct netlink_ext_ack *extack)
> > > +{
> > > +     struct bnxt *bp = netdev_priv(dev);
> > > +     u16 length = page_data->length;
> > > +     u8 *data = page_data->data;
> > > +     u8 page = page_data->page;
> > > +     u8 bank = page_data->bank;
> > > +     u16 bytes_copied = 0;
> > > +     u8 module_id;
> > > +     int rc;
> > > +
> > > +     /* Return -EOPNOTSUPP to fallback on .get_module_eeprom */
> > > +     if (!(bp->phy_flags & BNXT_PHY_FL_BANK_SEL))
> > > +             return -EOPNOTSUPP;
> >
> > Maybe:
> >
> > if (bank && !(bp->phy_flags & BNXT_PHY_FL_BANK_SEL)) {
> >         // extack
> >         return -EINVAL;
> > }
> 
> BNXT_PHY_FL_BANK_SEL is a firmware capability to handle CMIS/bank
> parameters. It does not tell whether the hooked module is CMIS
> compliant.
> I think EOPNOTSUPP is an appropriate choice here.

See my comment above. This operation needs to be able to retrieve EEPROM
data from non-CMIS modules as well.

> 
> 
> >
> > This should allow you to get rid of patch #2.
> 
> I am not sure how we can get rid of patch #2. Patch #2 handles non CMIS modules.
> Can you please elaborate more.

All the complicated parsing performed in patch #2 is already performed
in ethtool(8) that knows to request the available pages. The kernel
will first try to retrieve these pages using
ethtool_ops::get_module_eeprom_by_page and fallback to
ethtool::get_module_eeprom in case of '-EOPNOTSUPP'.

By adjusting your implementation of
ethtool_ops::get_module_eeprom_by_page to handle non-CMIS modules you
will be able to avoid extending the legacy operation with all this
complex parsing.

> 
> >
> > > +
> > > +     rc = bnxt_module_status_check(bp);
> > > +     if (rc)
> > > +             return rc;
> >
> > You can add extack here. I see that this function always returns
> > '-EOPNOTSUPP' in case of errors, even when it does not make sense to
> > fallback to ethtool_ops::get_module_eeprom.
> Maybe -EIO can be used in one of these cases. I`ll check.
> 
> >
> > > +
> > > +     rc = bnxt_read_sfp_module_eeprom_info(bp, I2C_DEV_ADDR_A0, 0, 0, false,
> > > +                                           0, 1, &module_id);
> > > +     if (rc)
> > > +             return rc;
> > > +
> > > +     if (!BNXT_SFF_MODULE_BANK_SUPPORTED(module_id))
> > > +             return -EOPNOTSUPP;
> >
> > I believe this hunk can be removed given the first comment.
>   As I mentioned above we need this here to fallback.

No need to fallback, simply avoid making this operation CMIS specific.

> 
> Thanks,
> Vikas
> >
> > > +
> > > +     while (length > 0) {
> > > +             u16 chunk = ETH_MODULE_EEPROM_PAGE_LEN;
> > > +             int rc;
> > > +
> > > +             /* Do not access more than required */
> > > +             if (length < ETH_MODULE_EEPROM_PAGE_LEN)
> > > +                     chunk = length;
> > > +
> > > +             rc = bnxt_read_sfp_module_eeprom_info(bp,
> > > +                                                   I2C_DEV_ADDR_A0,
> >
> > page_data->i2c_address
> >
> > > +                                                   page, bank,
> > > +                                                   true, page_data->offset,
> > > +                                                   chunk, data);
> > > +             if (rc)
> >
> > You can add a meaningful extack here according to the return code.
> >
> > > +                     return rc;
> > > +
> > > +             data += chunk;
> > > +             length -= chunk;
> > > +             bytes_copied += chunk;
> > > +             page++;
> > > +     }
> >
> > I'm not sure why the loop is required? It seems
> > bnxt_read_sfp_module_eeprom_info() is able to read
> > 'ETH_MODULE_EEPROM_PAGE_LEN' bytes at once, which is the maximum:
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ethtool/eeprom.c#n234
> >
> > > +
> > > +     return bytes_copied;
> > > +}
> > > +
> > >  static int bnxt_nway_reset(struct net_device *dev)
> > >  {
> > >       int rc = 0;
> > > @@ -4172,6 +4226,7 @@ const struct ethtool_ops bnxt_ethtool_ops = {
> > >       .set_eee                = bnxt_set_eee,
> > >       .get_module_info        = bnxt_get_module_info,
> > >       .get_module_eeprom      = bnxt_get_module_eeprom,
> > > +     .get_module_eeprom_by_page = bnxt_get_module_eeprom_by_page,
> > >       .nway_reset             = bnxt_nway_reset,
> > >       .set_phys_id            = bnxt_set_phys_id,
> > >       .self_test              = bnxt_self_test,
> > > --
> > > 2.18.1
> > >


