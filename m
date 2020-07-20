Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A665226D77
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389199AbgGTRpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:45:22 -0400
Received: from mail-dm6nam12on2133.outbound.protection.outlook.com ([40.107.243.133]:9696
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729431AbgGTRpV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 13:45:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYYXiEriCRMPemz3w0MJa2a/jW3588lP6+512g7+rLekYudxiR1bonDLQqtRh5PlG4dfMpse4SJWkBTpngp7Urz5LX1wA9HYhSkQcgCd1mEo1XSAE8tH6vfBAuGPtAbrq0kOoQ67LRXBr0FKxKbmEfJ3iC7tDs7znof/8BJfsshdW9o7qWnxQY0+8DCKXm/eqY03zu4gUECWoG6QZiaLVP3Wg7J16ZNx2GTd/YS9z+k9bAnmTI1daXKpILXAcSRiPFJP/0kPq6Vesi+o30ur7BObwnMKmpXr+4QyHXsVuFVkeDEd7fA3dG1qZE08a3shrSgeerERjFFBZxxYYnme4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkU+HB9wfxtpwSDqCP93JsRq/RBp+3Zs6gBTX/0JdHU=;
 b=aMa/cLgM1CUyF7+eWToCInLbyb/+FoY1cAolJ4tYIMd6xpeoDxv/YnSiEx1OVjvy7nafzDJ6PJOxQ1ZkrvHNGqKoIEdAJFK1ChGa2dQys5JuE6VeX4VrNmmbjsUFnha9C3dpwV+OoPr3qWKjMtDDSdqQ8HsyaczNXkK/NQ8M5bRpTwkF0UM+Tr+CZlD0eJ1sCD3kdHv7omSfSva8DuwwanpCiJpQF/0dgHFnhvpztxqaUoNGxFUBnlahTVdGXd7U7zjY+0R7LTVENmJAUFhH5e05/Jo7FiSI8brAgaP+9k1EJpsVIukLnYi2mIGvHCu7HCUTvsnVZv4G12/h8fGcoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkU+HB9wfxtpwSDqCP93JsRq/RBp+3Zs6gBTX/0JdHU=;
 b=WkGXNNMfBHaTTcIbq7D5GVP64i1XsAkPz03LZuB8GYKz48leNlQMkoZs1It/FoesewQv+8bu5g1htAF4A++hNjXPbgNwQoMPKnKOcmeVOhNAoVkXlhmyl80HM4yF0WFHSNNV8l7rKL3m1iOxfkEnfdPprcCWltzQjII1VAPhjl4=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB1330.namprd21.prod.outlook.com
 (2603:10b6:208:92::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.3; Mon, 20 Jul
 2020 17:45:18 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::f5a4:d43f:75c1:1b33%5]) with mapi id 15.20.3239.001; Mon, 20 Jul 2020
 17:45:18 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Sriram Krishnan <srirakr2@cisco.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>
CC:     "mbumgard@cisco.com" <mbumgard@cisco.com>,
        "ugm@cisco.com" <ugm@cisco.com>, "nimm@cisco.com" <nimm@cisco.com>,
        "xe-linux-external@cisco.com" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] net: hyperv: add support for vlans in netvsc driver
Thread-Topic: [PATCH v3] net: hyperv: add support for vlans in netvsc driver
Thread-Index: AQHWXrU+cNEwHb7+0Uu0LFIibsmHIakQvTfw
Date:   Mon, 20 Jul 2020 17:45:18 +0000
Message-ID: <BL0PR2101MB09304B3A612EBB45127CFCEDCA7B0@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20200720164551.14153-1-srirakr2@cisco.com>
In-Reply-To: <20200720164551.14153-1-srirakr2@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-20T17:45:17Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=584e7390-cbe8-4698-8c01-7a55d726e483;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: cisco.com; dkim=none (message not signed)
 header.d=none;cisco.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cef5e128-6f16-4828-396e-08d82cd4aad4
x-ms-traffictypediagnostic: BL0PR2101MB1330:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB13302423AB6A115FAE01F0E8CA7B0@BL0PR2101MB1330.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UHBv1yOT2E3sZZlVDjUPAAA7ooQUQ/eFiAZaV/VjUS9d0MVbb8I7OeFGvVsFx2DQmrxuxCaFvFR8SpbNwWurDs1Rha5hqK7eAJSxOpYKLUEoF/eHnHJloyArWcUyOpV3GPbssQrHkEgHpUUKqf3W8UyJv/m4r2JiPkQxbCVGSwUloDtwX11F1/0vT03NnijStBAseytQ9XN9cqGMzfDNzVpZ7DeLao07pSavtCb6BrTUmwd7fo6IYCg7a2Gt+JJmpQUL0YkXa/XZMkA8jgndhwi5EfEazB2OHusU+XW5Kz5zxEWHQ7Uqhpjsp/PWKU5c
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(366004)(346002)(39860400002)(376002)(316002)(8990500004)(71200400001)(33656002)(8676002)(54906003)(110136005)(478600001)(4326008)(64756008)(66556008)(76116006)(26005)(186003)(8936002)(66946007)(66476007)(5660300002)(86362001)(82960400001)(82950400001)(66446008)(53546011)(6506007)(7416002)(55016002)(9686003)(7696005)(2906002)(10290500003)(52536014)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: pL0mZDzSbXm8RKUIFGkPipKYjmT96r+0qXtnQ2456issCuRnDYXzXuerQBRNRRvTKfrq5G1gF5tROQScVYXmeDNoXyOH3TN4d5Qw1k69uWWXfXPzrRmh8FiIqF5n8dCvpulUKS6yG8X2THHgZuqWtmUzu/kz60LnDanr3PyomPnkeZmOl9sPChBMMpOZxBfms2cLy9YUQs20wuVzB4+9sQLDDmmQqTFGJm3vwG1dexBhefPcAKaU9EBym4Yz9TJ36p8fRWYJlitPqBTViRg74IYcWZcLwhMEyl6aHx6XueEzWNV9znIehjv/h4732pD/Yzx6QAhaLgoL2EuIB1N4rkQ2Y8JsRyYXnvpKE9Xn/bhjaKVMF4DwDMVYTRPlBBqPtMuN7c6ZtcK+qLpCXTTLeNIerZHF7Eagnjom29M511gcb/ffNnFZispnmkOD1nVsqWAn5Cx1Nd1B5NETkIkZ7dVk2IktSjCkX/sEDAkgu1KyJQL41e3Mc2ieG0i+tudGnbfbwi2upL6aG84Sw44KFPjcesE2uZvIzUKsRNRPw6ZkNM+aUimulQUphI/9UkqVRNSJUFtlMLrCOxqAlPIMqWZHjM3SO9Qu1TNFyG26DbWRHFQBj+2r6UY2wG/CdMNa1kkHQ0J2ajvAAtTV0AQZqA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cef5e128-6f16-4828-396e-08d82cd4aad4
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jul 2020 17:45:18.1970
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OIzhSWrXfo3aNNneUD6heZ4O3nIACG1w8vwEAzo8KXI4j4nOZRmvFJuznrzi7z/WjXjznDXasxg2xyCEyT248g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB1330
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Sriram Krishnan <srirakr2@cisco.com>
> Sent: Monday, July 20, 2020 12:46 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger <sthemmin@microsoft.com>;
> Wei Liu <wei.liu@kernel.org>
> Cc: mbumgard@cisco.com; ugm@cisco.com; nimm@cisco.com; xe-linux-
> external@cisco.com; David S. Miller <davem@davemloft.net>; Jakub Kicinski
> <kuba@kernel.org>; linux-hyperv@vger.kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: [PATCH v3] net: hyperv: add support for vlans in netvsc driver
>=20
> Vlan tagged packets are getting dropped when used with DPDK that uses
> the AF_PACKET interface on a hyperV guest.
>=20
> The packet layer uses the tpacket interface to communicate the vlans
> information to the upper layers. On Rx path, these drivers can read the
> vlan info from the tpacket header but on the Tx path, this information
> is still within the packet frame and requires the paravirtual drivers to
> push this back into the NDIS header which is then used by the host OS to
> form the packet.
>=20
> This transition from the packet frame to NDIS header is currently missing
> hence causing the host OS to drop the all vlan tagged packets sent by
> the drivers that use AF_PACKET (ETH_P_ALL) such as DPDK.
>=20
> Here is an overview of the changes in the vlan header in the packet path:
>=20
> The RX path (userspace handles everything):
>   1. RX VLAN packet is stripped by HOST OS and placed in NDIS header
>   2. Guest Kernel RX hv_netvsc packets and moves VLAN info from NDIS
>      header into kernel SKB
>   3. Kernel shares packets with user space application with PACKET_MMAP.
>      The SKB VLAN info is copied to tpacket layer and indication set
>      TP_STATUS_VLAN_VALID.
>   4. The user space application will re-insert the VLAN info into the fra=
me.
>=20
> The TX path:
>   1. The user space application has the VLAN info in the frame.
>   2. Guest kernel gets packets from the application with PACKET_MMAP.
>   3. The kernel later sends the frame to the hv_netvsc driver. The only w=
ay
>      to send VLANs is when the SKB is setup & the VLAN is is stripped fro=
m the
>      frame.
>   4. TX VLAN is re-inserted by HOST OS based on the NDIS header. If it se=
es
>      a VLAN in the frame the packet is dropped.
>=20
> Cc: xe-linux-external@cisco.com
> Cc: Sriram Krishnan <srirakr2@cisco.com>
> Signed-off-by: Sriram Krishnan <srirakr2@cisco.com>
> ---
>  drivers/net/hyperv/netvsc_drv.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>=20
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_=
drv.c
> index 6267f706e8ee..2a25b4352369 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -605,6 +605,29 @@ static int netvsc_xmit(struct sk_buff *skb, struct
> net_device *net, bool xdp_tx)
>  		*hash_info =3D hash;
>  	}
>=20
> +	/* When using AF_PACKET we need to remove VLAN from frame
> +	 * and indicate VLAN information in SKB so HOST OS will
> +	 * transmit the VLAN frame
> +	 */
> +	if (skb->protocol =3D=3D htons(ETH_P_8021Q)) {
> +		u16 vlan_tci =3D 0;
> +		skb_reset_mac_header(skb);
> +		if (eth_type_vlan(eth_hdr(skb)->h_proto)) {
> +			int pop_err;
> +			pop_err =3D __skb_vlan_pop(skb, &vlan_tci);
> +			if (likely(pop_err =3D=3D 0)) {
> +				__vlan_hwaccel_put_tag(skb,
> htons(ETH_P_8021Q), vlan_tci);
> +
> +				/* Update the NDIS header pkt lengths */
> +				packet->total_data_buflen -=3D VLAN_HLEN;

packet->total_bytes should be updated too.

Thanks,
- Haiyang

