Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFE43995F8
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 00:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhFBWcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 18:32:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:33746 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbhFBWcy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 18:32:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 152MJwoa066623
        for <netdev@vger.kernel.org>; Wed, 2 Jun 2021 22:31:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2020-01-29;
 bh=tyKMhEFCS3xwBcGta9jVZOzphPWWF174tAH9O62qZu4=;
 b=GSBMGom8PXJMKicN2G5dXdZPPqtJA/zCfa/iWGZqwDAvfngmpNoQLFbew8oSpAtZmIXx
 PumZtkKBFLs1xbpEYU36Cdq0/I3IDkcnzXNj22NnU4XwL2LrXp/+/OP/VaLQ5hizoqOa
 wg904k8d74SWITNMc27zQWsFkme8CeEkT7svrq/2IhRq3FUiFlNcRo87fsJfExZZ3dfn
 6nKf00lrq1lzPDPxtipAIqmxUHzLWPTQe23FEEgjJ0cadNRLet0NjcoLkF1rR1hsGy3B
 /KkYJLYDkjGLanJDsO7BQ186bx48alKeol8N+DddjftWFx4z3K5dxIfG3SHNjp9TQ0ov 4Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 38ue8phu8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 22:31:10 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 152MGXdD149196
        for <netdev@vger.kernel.org>; Wed, 2 Jun 2021 22:31:09 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 38ubneb035-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 22:31:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgZfhIfOvyp74gESKlC2LaIPLEA9Gj5BrJtXOepGMmgIsmazz+PYZl/bePke/PR/ko5A+yzKRiqbNVqgubw/eTs9igyZsUjnNOdOfFs8J+N3MNTehFpdxoxlgsQc8V+g5yC+qgiLvQhwdml04pMyJRAf1a/KvZtTKTDPEH/hs7Lx7mULSGvTBOOi0JVYkUpd+tcON7q7lMwDvNAVJfO/Yb7dXq7hMaewQtF+fqn/2qTZqL4/LO+i4wluMKuN4NvyZapb2Vb+uyAS9HoWalW4uCAuvRpBCANPKN1zFOb14fjyuZJsSKWtnoLxW9JmaEFczcmUsmq885SjfK0gOeUuSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tyKMhEFCS3xwBcGta9jVZOzphPWWF174tAH9O62qZu4=;
 b=gZwAL3Cil+3whVRcXq/5V/433tt2ocMhgg5wZFYk/BXU4lv/ro098xm1CrB37QxUNL1gPvmXYzoS2eIHY1bIDD9VJ5ccV5ZN4zSv9sDNrKjU7mQXHYhphKCh12XLX2o/FrbnO70i2AXhkSSIzNk+LZiRmH9N3zEqyiUtBffWJcbUt8AXAiFhbNqCGR2U4TQUiEu4RhKkjlK1l3RwaoK4pxS5QIeDLLVOQq0mQduX47o6bgUWuENjwkSmAd2Usnuz6q4CjR908oLCmRwoHH+If9drGJgLUWDxcn4dt6MMs3mP8NL27iLsq6RXYMIHMeborGW/bWcRebdhJ7PXek2nfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tyKMhEFCS3xwBcGta9jVZOzphPWWF174tAH9O62qZu4=;
 b=mjITtpFeAFBoKE2STtpnbWnIjQGz1AHfOFnbJV1mtVR6sGtqVpYn03LoqdymV5MjmkU7CYOpUKYisE/pq9tHbuwY66i2PxgINiQUjjooLI+n0M+wihFFTaVEFGUdwA0LJ9bYWCevGUG7xPXBF6eVYkatpzjv1wGriYNNiby4cTo=
Received: from PH0PR10MB4504.namprd10.prod.outlook.com (2603:10b6:510:42::5)
 by PH0PR10MB5466.namprd10.prod.outlook.com (2603:10b6:510:e2::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 22:31:07 +0000
Received: from PH0PR10MB4504.namprd10.prod.outlook.com
 ([fe80::3981:8836:f924:3927]) by PH0PR10MB4504.namprd10.prod.outlook.com
 ([fe80::3981:8836:f924:3927%4]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 22:31:07 +0000
From:   Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Geneve udp tx checksum offload not working over mlx5 when options
 included 
Thread-Topic: Geneve udp tx checksum offload not working over mlx5 when
 options included 
Thread-Index: AQHXV/5BVHISWL+jyEebuTSv8Mrzuw==
Date:   Wed, 2 Jun 2021 22:31:07 +0000
Message-ID: <PH0PR10MB450433FDBA4561A330FE27B0AC3D9@PH0PR10MB4504.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [24.55.51.115]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84186b2f-163a-456f-04b5-08d926161d9a
x-ms-traffictypediagnostic: PH0PR10MB5466:
x-microsoft-antispam-prvs: <PH0PR10MB54664E7DE46C87D383F5C0F4AC3D9@PH0PR10MB5466.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gHikduG+9OwKQUqxC+6FizOo/aORHyQd3Hk1IphUHfmjebYtI9B7eoK8rj6UgJZv2846+M5zKeWQyhJuprUlEFYFZ6/1JRXMnq4k7bdoBatyMNEHRS0v+mLUouz4HRUE85AuAhwjdcMbn9tBcnkopJEJJJDOLpEzvsidgLuNGGTAoq4CvvhgbsFO4DFxGxK5X+A0oWej/khpuTJWOCeHWUz0vycTopc0YV23b45hSQm4fJbazoW9VfhMyhY236aD3L3zFhq1u5OA/6SELtMfT1rBB4EkZnoi1/ooub8v7t8HWUGAbMmgeX2E+PtknCqVCy12SMinH7kYku55yMMcYIyI1iV075WJNKVTbecQFuQbg9JQ6CG8thwKT8iYJEwA85F2wWrZVRYUL2BDc96eLUxHmi4VVzvT1WJ+V/s0NbJMKmPmdFyIvRicut2qW7LBIhrnKsi52m38y+zxbPmwfCpSPDOvCb9CvmUTPY0kEABeJFV9h7yWCMbsviu1AL/BDN6iUq7DguOV1KD4N5BgLrfRpvpN41LplVJPx5KO/LptQKRcjO/WRDrunDH8SpyaLqHgG1fQZwTYWcMlpwKqRJIylor8Sj++L2nu4ZxzzKM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4504.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(366004)(39860400002)(346002)(86362001)(38100700002)(122000001)(7696005)(33656002)(6916009)(2906002)(8936002)(8676002)(316002)(83380400001)(66446008)(478600001)(5660300002)(55016002)(186003)(26005)(66556008)(71200400001)(64756008)(91956017)(66946007)(76116006)(4743002)(9686003)(52536014)(66476007)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?tmW5M8w88oSja7cUMduxPr99ufmydjf3s8Z8GJyQRSJ4mjTM+1jiN0DZYz?=
 =?iso-8859-1?Q?NQYZs6Nm26vXZlKyW4xIi+nTT7U2HTDIzJbhgyiv+HAtcvX5Dl0x1YuYGZ?=
 =?iso-8859-1?Q?buI/UVkXobYAkr40RtSfMC3OtYPDOlp3Wq3Qa36pyT59EciGvkQJW0quwI?=
 =?iso-8859-1?Q?Nm3QlRHcHY1RPSKZQNnOO3NE5865YnF7g1xvCdSS8cVEo48jtUdhyPCA4P?=
 =?iso-8859-1?Q?eXOUx5NINX3Ax3j5R4c5PwO6LkZILCb6EHd1x/HYn6kNRwsKBqyliADmW+?=
 =?iso-8859-1?Q?tirVR+N0hlRgTz2WuxiLIoPLZxMSZ+gmQm4tdR8m0IbkKLTdk1ZSNz8paO?=
 =?iso-8859-1?Q?lhBLUc6sXnVKJnVn7C9B8KRz9nba0p5ntQ4QO7qn1N/PocKAyrWwUxzvlz?=
 =?iso-8859-1?Q?d0oF8VMeo+o2Oa5ppSC1nY13K1+OC4DTCAihyMpVvxktoDBiMxaavuwC+r?=
 =?iso-8859-1?Q?I5UxXyALtXh7wyQTei+ermOWsqefPTj3cps3fAvLd0CMmtdvrSD1JRUqQ6?=
 =?iso-8859-1?Q?1kXjwrnpExATJD171KvbFP9JrOG63lYAoeGRwCFFrJLQ2PvRwHNeh+K5Jf?=
 =?iso-8859-1?Q?zdBYiR7g3zuWlW5Xsx7w6grrGfmJ+l8FpcwgCf8gmSRVojmJfCkXmu2Ktk?=
 =?iso-8859-1?Q?gJ9edmLqRSIAg4FkRyoAsjZeCeab8/3ZcZQpCxAx3L8UmFORS80qJkCG9n?=
 =?iso-8859-1?Q?19GQ1nSLBFvK61laOm8tSm0wJALNQ2IL/jTk0GRABHbs2mYSioGAFHK0oR?=
 =?iso-8859-1?Q?rFkwwrRjkgb9VCmClyUXXLxXZKCJRyJHOFxWQOhE4hr0qln7sG3Nj3iHQt?=
 =?iso-8859-1?Q?ALbDAcC1MdwryEZtLsZGULDDhrLTd0G0/21PBnl+S7y/R4MhyywZ3b4zNm?=
 =?iso-8859-1?Q?pjwvbtI0vR//ZhHmgOQIDR9ud/6uA/hZ1aYqzn4/NGPgOsHSOwUddsDwXX?=
 =?iso-8859-1?Q?UhjtHxsgf3su2VsAofYNGUSHN5WzM/Lvbuxz42KZslXBHqZKNGKk8TIKaA?=
 =?iso-8859-1?Q?XXACddqNL1w6d8mEgyuBl2TL/QoatDAH7VdMu7hc4EA6B4YCSZrA0CJBzt?=
 =?iso-8859-1?Q?pqQ9w4P7osRAM04Xj4qKNun8Dyn1J/3IzzQ878aG5wZKx+QPqDsCOig4/d?=
 =?iso-8859-1?Q?plgZE+EnPfQ0KUN72/9EggBGjiEgfN5kS/2QcPqofukZbfKPeVaiTo+a2i?=
 =?iso-8859-1?Q?zvQv19mDJ8ZWo5KKYRM3otPCO2t9Pt8lywXCz5j8gn64NzksD4i2RVGNwv?=
 =?iso-8859-1?Q?ZrKQ1QQ9k1zTp5wsB/pcIAIWK02lC1S9v07HUEYl0dnU7MGDCGv1I9gxd8?=
 =?iso-8859-1?Q?VI2XKbQDlv7CjbeMJz3HBNJaYhh5VElxUeQ4+oNtPAfaMcU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4504.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84186b2f-163a-456f-04b5-08d926161d9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2021 22:31:07.6837
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 27C2pSIZHSc1AEN7UEcXt6ER5tIciCnPZJB45+evQbU8NTh57xhcw1Anl0VKZzoNW8nURv6MVs3MP8n8BhSCsYzv3+V6T796WYKLuKGzzLM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5466
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10003 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 spamscore=0 malwarescore=0 mlxscore=0 mlxlogscore=962 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020143
X-Proofpoint-GUID: jWOWS-XAoVGfrzYjLIG1M3AJRwRjCK_Z
X-Proofpoint-ORIG-GUID: jWOWS-XAoVGfrzYjLIG1M3AJRwRjCK_Z
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10003 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 adultscore=0 suspectscore=0 lowpriorityscore=0 spamscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With mlx5 (Mellanox CX5), UDP tx csum offload is not happening=0A=
on geneve packets when "options" are present in the geneve header.=0A=
The kernel computes it instead.=0A=
=0A=
The offload feature gets disabled by mlx5e_features_check=0A=
because it is expecting a 8 byte regular (vxlan) header.=0A=
Whereas with OVN we include 8 byte options to make it a 16 byte geneve head=
er.=0A=
=0A=
[drivers/net/ethernet/mellanox/mlx5/core/en_main.c]=0A=
=0A=
netdev_features_t mlx5e_features_check(struct sk_buff *skb,=0A=
                                       struct net_device *netdev,=0A=
                                       netdev_features_t features)=0A=
{=0A=
        struct mlx5e_priv *priv =3D netdev_priv(netdev);=0A=
=0A=
        features =3D vlan_features_check(skb, features);=0A=
        features =3D vxlan_features_check(skb, features);     <-------=0A=
        ...=0A=
}=0A=
=0A=
[include/net/vxlan.h]=0A=
static inline netdev_features_t vxlan_features_check(struct sk_buff *skb,=
=0A=
                                                     netdev_features_t feat=
ures)=0A=
{=0A=
        ...=0A=
        if ((l4_hdr =3D=3D IPPROTO_UDP) &&=0A=
            (skb->inner_protocol_type !=3D ENCAP_TYPE_ETHER ||=0A=
             skb->inner_protocol !=3D htons(ETH_P_TEB) ||=0A=
             (skb_inner_mac_header(skb) - skb_transport_header(skb) !=3D=0A=
              sizeof(struct udphdr) + sizeof(struct vxlanhdr)) ||=0A=
             (skb->ip_summed !=3D CHECKSUM_NONE &&=0A=
              !can_checksum_protocol(features, inner_eth_hdr(skb)->h_proto)=
)))=0A=
                return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);=
=0A=
        ...=0A=
}=0A=
=0A=
This=0A=
=0A=
(skb_inner_mac_header(skb) - skb_transport_header(skb) !=3D=0A=
              sizeof(struct udphdr) + sizeof(struct vxlanhdr))=0A=
=0A=
restricts the header size to 8 bytes.=0A=
=0A=
Why is the geneve tx offloads limited to 8 byte headers only ?=0A=
=0A=
Thanks for your help.=0A=
=0A=
Venkat=0A=
