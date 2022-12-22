Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79A0654588
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 18:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbiLVRSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 12:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiLVRSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 12:18:16 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC062B242;
        Thu, 22 Dec 2022 09:18:14 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id AD0A432007E8;
        Thu, 22 Dec 2022 12:18:13 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 22 Dec 2022 12:18:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pjd.dev; h=cc:cc
        :content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1671729493; x=
        1671815893; bh=Ie7Sm1B9QX/iVzbZTIN/o7wioiVwhbSkTpBMrCn9us8=; b=O
        qnNT358/3ACQpHdAjzHEA6KPtA06zlU1WtB98KDZmCcrasO1+m4WeFU4dH8B0T3d
        cQHSVXWGb6dt27GSZgyB7GRDeahGqitChOPFmWWnI9vjnseUYfozuDYHkxoqg3cb
        LPim96NSgUZeDJ4+vILPtFCYeHedseYL93JuuHQrZsJgtTnS+hfQiuhE+wyDdOI6
        E+OJRVhHIhK+YaeU5KBakBMseZycYu5nQtUk6VPkwIRjlD3ppUE1aE2apMeb8Qoc
        ORl+CWTN82TjhiPcesRizLUNw3eHF2L8x6o0xlxUAbzINFKZ8VwVjuHSa02Ogk29
        NEn2G3JcdkDh4PYVHXBJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1671729493; x=
        1671815893; bh=Ie7Sm1B9QX/iVzbZTIN/o7wioiVwhbSkTpBMrCn9us8=; b=j
        u9YuKV8M6pdqGFclsIKdiJn0mZ0wzU2zUXOgLJptnEmJ/qVjE15yKqLfMMnJf/L6
        Oa/vT71G5FQMiFwD8OKWnwI4K3hffCdzNEGRy4qCUKOz6/RPX+ALUFvWjw4Ur8sG
        xiUeLq2asq2J9C71agRcXFZHGA0JyQgh29yEmKqmTDrQJDWzk72wFcAWlh01BwR0
        bYsing0XRiJrEX+JILhZ8nv6aS5Rdfpv2GtcSG1eiMgqYoIVfrhNvSwKdQbzYGKC
        8FNYGty7bJAaBZuiW3LORxnL1RlFH31mKWpdkL1gzN1GKYZHHzRtUg+ac6Flhlcr
        RonxhJsO2kWXVxIRC5tuA==
X-ME-Sender: <xms:VJGkY_PIUC6oaUk2OeM_fkBumAZ94Ne4P7E0_uQSZOlWqHf0HgJrLw>
    <xme:VJGkY5_96Y4wAIeS2F3209PjMHfAHvru7J9SXgWI4LtDurAsd9y-c4dDGNS2npR08
    YxorCTgavfnD8SmVLk>
X-ME-Received: <xmr:VJGkY-QucrujSxwZpJxn41vwz99F6gcTyKqsJjG6gUb8SdlEu_O5D3Ovbn1m9oG_fBz-K8QT-LX0DH5zNru7pJXHKdF7BIlw7rie>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrhedtgddutddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurheptgfghfggufffkfhfvegjvffosehtqhhmtdhhtdejnecuhfhrohhmpefrvght
    vghrucffvghlvghvohhrhigrshcuoehpvghtvghrsehpjhgurdguvghvqeenucggtffrrg
    htthgvrhhnpedutdfhvddvudfgieekhfektddvveefkeejffehgffhkeejhfevteffgfel
    vdevhfenucffohhmrghinhepughmthhfrdhorhhgpdhpohhinhhtrdhnvghtnecuvehluh
    hsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepphgvthgvrhesphhj
    ugdruggvvh
X-ME-Proxy: <xmx:VJGkYzs70pzfXyGujzETBZv_OcCBEk3pAk8dfdtQRyhuvMle0w1eDw>
    <xmx:VJGkY3f-Yaevvs4iWu5J3OfAOfZKw0pvqLuxcTghVdHPdmOzTBHdUQ>
    <xmx:VJGkY_3e8pcsJj2ikjFcx2vfcGWd73FNKCp9g8hlYG0R5S_VcIqtQw>
    <xmx:VZGkY5st2pu39HPKh70rnMuMyOy4mIlc4TRxlb9kX0IE5MfxU8gCsA>
Feedback-ID: i9e814621:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Dec 2022 12:18:12 -0500 (EST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Peter Delevoryas <peter@pjd.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH 3/3] net/ncsi: Add NC-SI 1.2 Get MC MAC Address command
Date:   Thu, 22 Dec 2022 09:18:00 -0800
Message-Id: <8BE94C37-5233-49B4-8DCD-473D71CDA78C@pjd.dev>
References: <a198f9fa6737b22ed2839a5dbfbcfdf6c6d7508d.camel@redhat.com>
Cc:     sam@mendozajonas.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, joel@jms.id.au, gwshan@linux.vnet.ibm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <a198f9fa6737b22ed2839a5dbfbcfdf6c6d7508d.camel@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
X-Mailer: iPhone Mail (20B110)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Dec 22, 2022, at 2:53 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> =EF=BB=BFOn Tue, 2022-12-20 at 21:22 -0800, Peter Delevoryas wrote:
>> This change adds support for the NC-SI 1.2 Get MC MAC Address command,
>> specified here:
>>=20
>> https://www.dmtf.org/sites/default/files/standards/documents/DSP0222_1.2W=
IP90_0.pdf
>>=20
>> It serves the exact same function as the existing OEM Get MAC Address
>> commands, so if a channel reports that it supports NC-SI 1.2, we prefer
>> to use the standard command rather than the OEM command.
>>=20
>> Verified with an invalid MAC address and 2 valid ones:
>>=20
>> [   55.137072] ftgmac100 1e690000.ftgmac eth0: NCSI: Received 3 provision=
ed MAC addresses
>> [   55.137614] ftgmac100 1e690000.ftgmac eth0: NCSI: MAC address 0: 00:00=
:00:00:00:00
>> [   55.138026] ftgmac100 1e690000.ftgmac eth0: NCSI: MAC address 1: fa:ce=
:b0:0c:20:22
>> [   55.138528] ftgmac100 1e690000.ftgmac eth0: NCSI: MAC address 2: fa:ce=
:b0:0c:20:23
>> [   55.139241] ftgmac100 1e690000.ftgmac eth0: NCSI: Unable to assign 00:=
00:00:00:00:00 to device
>> [   55.140098] ftgmac100 1e690000.ftgmac eth0: NCSI: Set MAC address to f=
a:ce:b0:0c:20:22
>>=20
>> IMPORTANT NOTE:
>>=20
>> The code I'm submitting here is parsing the MAC addresses as if they are
>> transmitted in *reverse* order.
>>=20
>> This is different from how every other NC-SI command is parsed in the
>> Linux kernel, even though the spec describes the format in the same way
>> for every command.
>>=20
>> The *reason* for this is that I was able to test this code against the
>> new 200G Broadcom NIC, which reports that it supports NC-SI 1.2 in Get
>> Version ID and successfully responds to this command. It transmits the
>> MAC addresses in reverse byte order.
>>=20
>> Nvidia's new 200G NIC doesn't support NC-SI 1.2 yet. I don't know how
>> they're planning to implement it.
>=20
> All the above looks like a good reason to wait for at least a
> stable/documented H/W implementation, before pushing code to the
> networking core.

I guess that=E2=80=99s a good point.

>=20
>> net/ncsi/ncsi-cmd.c    |  3 ++-
>> net/ncsi/ncsi-manage.c |  9 +++++++--
>> net/ncsi/ncsi-pkt.h    | 10 ++++++++++
>> net/ncsi/ncsi-rsp.c    | 45 +++++++++++++++++++++++++++++++++++++++++-
>> 4 files changed, 63 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
>> index dda8b76b7798..7be177f55173 100644
>> --- a/net/ncsi/ncsi-cmd.c
>> +++ b/net/ncsi/ncsi-cmd.c
>> @@ -269,7 +269,8 @@ static struct ncsi_cmd_handler {
>>    { NCSI_PKT_CMD_GPS,    0, ncsi_cmd_handler_default },
>>    { NCSI_PKT_CMD_OEM,   -1, ncsi_cmd_handler_oem     },
>>    { NCSI_PKT_CMD_PLDM,   0, NULL                     },
>> -    { NCSI_PKT_CMD_GPUUID, 0, ncsi_cmd_handler_default }
>> +    { NCSI_PKT_CMD_GPUUID, 0, ncsi_cmd_handler_default },
>> +    { NCSI_PKT_CMD_GMCMA,  0, ncsi_cmd_handler_default }
>> };
>>=20
>> static struct ncsi_request *ncsi_alloc_command(struct ncsi_cmd_arg *nca)
>> diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
>> index f56795769893..bc1887a2543d 100644
>> --- a/net/ncsi/ncsi-manage.c
>> +++ b/net/ncsi/ncsi-manage.c
>> @@ -1038,11 +1038,16 @@ static void ncsi_configure_channel(struct ncsi_de=
v_priv *ndp)
>>    case ncsi_dev_state_config_oem_gma:
>>        nd->state =3D ncsi_dev_state_config_clear_vids;
>>=20
>> -        nca.type =3D NCSI_PKT_CMD_OEM;
>>        nca.package =3D np->id;
>>        nca.channel =3D nc->id;
>>        ndp->pending_req_num =3D 1;
>> -        ret =3D ncsi_gma_handler(&nca, nc->version.mf_id);
>> +        if (nc->version.major >=3D 1 && nc->version.minor >=3D 2) {
>> +            nca.type =3D NCSI_PKT_CMD_GMCMA;
>> +            ret =3D ncsi_xmit_cmd(&nca);
>> +        } else {
>> +            nca.type =3D NCSI_PKT_CMD_OEM;
>> +            ret =3D ncsi_gma_handler(&nca, nc->version.mf_id);
>> +        }
>>        if (ret < 0)
>>            schedule_work(&ndp->work);
>>=20
>> diff --git a/net/ncsi/ncsi-pkt.h b/net/ncsi/ncsi-pkt.h
>> index c9d1da34dc4d..f2f3b5c1b941 100644
>> --- a/net/ncsi/ncsi-pkt.h
>> +++ b/net/ncsi/ncsi-pkt.h
>> @@ -338,6 +338,14 @@ struct ncsi_rsp_gpuuid_pkt {
>>    __be32                  checksum;
>> };
>>=20
>> +/* Get MC MAC Address */
>> +struct ncsi_rsp_gmcma_pkt {
>> +    struct ncsi_rsp_pkt_hdr rsp;
>> +    unsigned char           address_count;
>> +    unsigned char           reserved[3];
>> +    unsigned char           addresses[][ETH_ALEN];
>> +};
>> +
>> /* AEN: Link State Change */
>> struct ncsi_aen_lsc_pkt {
>>    struct ncsi_aen_pkt_hdr aen;        /* AEN header      */
>> @@ -398,6 +406,7 @@ struct ncsi_aen_hncdsc_pkt {
>> #define NCSI_PKT_CMD_GPUUID    0x52 /* Get package UUID                 *=
/
>> #define NCSI_PKT_CMD_QPNPR    0x56 /* Query Pending NC PLDM request */
>> #define NCSI_PKT_CMD_SNPR    0x57 /* Send NC PLDM Reply  */
>> +#define NCSI_PKT_CMD_GMCMA    0x58 /* Get MC MAC Address */
>>=20
>>=20
>> /* NCSI packet responses */
>> @@ -433,6 +442,7 @@ struct ncsi_aen_hncdsc_pkt {
>> #define NCSI_PKT_RSP_GPUUID    (NCSI_PKT_CMD_GPUUID + 0x80)
>> #define NCSI_PKT_RSP_QPNPR    (NCSI_PKT_CMD_QPNPR   + 0x80)
>> #define NCSI_PKT_RSP_SNPR    (NCSI_PKT_CMD_SNPR   + 0x80)
>> +#define NCSI_PKT_RSP_GMCMA    (NCSI_PKT_CMD_GMCMA  + 0x80)
>>=20
>> /* NCSI response code/reason */
>> #define NCSI_PKT_RSP_C_COMPLETED    0x0000 /* Command Completed        */=

>> diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
>> index 7a805b86a12d..28a042688d0b 100644
>> --- a/net/ncsi/ncsi-rsp.c
>> +++ b/net/ncsi/ncsi-rsp.c
>> @@ -1140,6 +1140,48 @@ static int ncsi_rsp_handler_netlink(struct ncsi_re=
quest *nr)
>>    return ret;
>> }
>>=20
>> +static int ncsi_rsp_handler_gmcma(struct ncsi_request *nr)
>> +{
>> +    struct ncsi_dev_priv *ndp =3D nr->ndp;
>> +    struct net_device *ndev =3D ndp->ndev.dev;
>> +    struct ncsi_rsp_gmcma_pkt *rsp;
>> +    struct sockaddr saddr;
>> +    int ret =3D -1;
>> +    int i;
>> +    int j;
>> +
>> +    rsp =3D (struct ncsi_rsp_gmcma_pkt *)skb_network_header(nr->rsp);
>> +    saddr.sa_family =3D ndev->type;
>> +    ndev->priv_flags |=3D IFF_LIVE_ADDR_CHANGE;
>> +
>> +    netdev_warn(ndev, "NCSI: Received %d provisioned MAC addresses\n",
>> +            rsp->address_count);
>> +    for (i =3D 0; i < rsp->address_count; i++) {
>> +        netdev_warn(ndev, "NCSI: MAC address %d: "
>> +                "%02x:%02x:%02x:%02x:%02x:%02x\n", i,
>> +                rsp->addresses[i][5], rsp->addresses[i][4],
>> +                rsp->addresses[i][3], rsp->addresses[i][2],
>> +                rsp->addresses[i][1], rsp->addresses[i][0]);
>> +    }
>=20
> You must avoid this kind of debug messages on 'warn' level (more
> below). You could consider pr_debug() instead or completely drop the
> message.

Oh ok, I=E2=80=99ll change it to a debug message when I resubmit it.

Thanks for your comments!

>=20
> Cheers,
>=20
> Paolo
>=20

