Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A86B52CBD0
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 08:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbiESGL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 02:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbiESGL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 02:11:26 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2065.outbound.protection.outlook.com [40.107.102.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09C535844
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 23:11:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmZj3LGb1WCkRbhxeESnp7HDFqiGZfXMD0CaoCF6YjblCWx6aEttbA8GUUaLcEaMP67HAHvWesoYgIS+5P/fLJAy2paLTe5C6MsdPvkirZhgRl2cQPmTipicKCvwvTTW5yVA7ytMg2fK0nEutu11IfYcTErqMIco/BqaCzKWbjkdgtBgO6ayrHGe+IUcQpFL/hPUAwPfEAi/XtRjPYzbuzczu1m8plcwqYj5QQLM+Y+/8NoRDxYkvnEdVz21qK2dHpVf5TOOJo+r0zbxDwPsIirWuL8pO4WCPKDokOLh835Fmq79Qr7lBgTE6/urHfWd3sK1XrroePfzUmAcCzHnXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2jzCkFwgkLKmSeo5VJZ6hVKDh8upD48jJi9XJgSk2I4=;
 b=F4EfC898BITiAtrx9FLzF9udz5WCm1qNylkG73z7eGbV+3aTLxrlMuw7KUAZdRAPBQFSxoHqblW/6ncBb14GnRZ+XeKjdB4tNOuvBgeorxCw7s/IIRuc4c4CYcGFPwQn3fIEMEwGpBFEf1B4uJnCsltpCvcwkZzt+b51lptMcuOyobaNktaUvzxpzyIiC1QzQ3fqwCihZMPPE5+TqbBWks5EhN7+eAsXFcmcICTSfyaOS+runtfEq9qF7m5zwX8pB8iwStVcio6EHdfVW8mrBKiGSMuNBxuFG5Sc419rDfyDQmCQ7IGSWueIfPSeVCHfG0Nv6jhAE2RN6/oZxC+YXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digitizethings.com; dmarc=pass action=none
 header.from=digitizethings.com; dkim=pass header.d=digitizethings.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=digitizethings.onmicrosoft.com; s=selector2-digitizethings-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2jzCkFwgkLKmSeo5VJZ6hVKDh8upD48jJi9XJgSk2I4=;
 b=ZRsSlJ5sK+HG7YCfBJVeEbro+Ed9XOT8H8MkDHP5oafqyN9+cPXmRIN8K6DvWb8wUwtT3WlVceFYO/5k6m1Uw6EvVuOvNaa+/rHMXZQslLnTdik3YifEeT3aTsyZssVDnzwxpr5V0EdCNCkWA6oG9oRQbuXplj3UlP3yS/EAIY8=
Received: from DM5PR20MB2055.namprd20.prod.outlook.com (2603:10b6:4:ba::36) by
 MWHPR2001MB1088.namprd20.prod.outlook.com (2603:10b6:300:ea::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Thu, 19 May
 2022 06:11:20 +0000
Received: from DM5PR20MB2055.namprd20.prod.outlook.com
 ([fe80::153b:3536:fbd:7783]) by DM5PR20MB2055.namprd20.prod.outlook.com
 ([fe80::153b:3536:fbd:7783%5]) with mapi id 15.20.5250.018; Thu, 19 May 2022
 06:11:20 +0000
From:   "Magesh  M P" <magesh@digitizethings.com>
To:     David Ahern <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: gateway field missing in netlink message
Thread-Topic: gateway field missing in netlink message
Thread-Index: AQHYa0bH05KyCxzYL0GO9TivoQNqpA==
Date:   Thu, 19 May 2022 06:11:20 +0000
Message-ID: <DM5PR20MB20556E23BCBFA74B17B29BC9AED09@DM5PR20MB2055.namprd20.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=digitizethings.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be15458a-d2ee-48d7-5275-08da395e6495
x-ms-traffictypediagnostic: MWHPR2001MB1088:EE_
x-microsoft-antispam-prvs: <MWHPR2001MB10886FED21C1789EE8FC238CAED09@MWHPR2001MB1088.namprd20.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1TuNbj5pPf42CrX+D5r/RrCsFyopCeE3TuN6Q2mEjwOfnXLhmFJbto2YTjYt75C84SNFDUz0yArYEeC8cmlYDdOc4mmL2m5XtHZSfANwARo+G5boSRykTmjj+PtsiIWxcsQYD0aGrhECtLOHuoLGkMhOxfeKz+jBDlTgMXi9PuhX0vBrGkIfv8YBjaNzEtywLBm+195Ng0zKBt3fVeJP2m2fLHQ2EHXbLHNTyK44Vd4mqVW7h5X9+dxsAWIYe1g92C3yZyWWOzYqdf31OVD1LLxNjQq/beInBS0sMlG0d2wWApD+X3l3VNSISkh7x0/+0ZXyhltb/FuCZcH6DidB+s9QwFDgK2ldQGoMOE7k//OF+yJMFLrjIqssTlsBriZSTYPl3+3Xp/KEG94Qh6r0M5ZcTcKgTUi9BA7CZTIdt3ramqPPG8uJMewGzXiNfO1+/XzlBtgqChqA8XtPu6+vuRvE+bgFo528TzWsj4EOzqpsDA5/3pwiQJAEsqz8G7eSuBmeDnoM1o+oZcPicAkcR456g5Vam8N8/DdCSGrSSYg5wnmhdeF36+0KI1FZsABbNCL6fY0H28i9E+5Bc/hLJQRqYUgxs9drsKYCCt7d8kbPE79NUhfjFZppoMvGC2VlAb1CxT4JsjqCqbJIZ+4zUYHnwQD0OPZMKkcaDZQ1E7yzCYVDoij9QXcppje97Z3qixDabkVgDG7ix/1YTUv3pQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR20MB2055.namprd20.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(376002)(39830400003)(136003)(396003)(366004)(38100700002)(83380400001)(316002)(33656002)(8676002)(7696005)(15650500001)(66556008)(66476007)(2906002)(86362001)(71200400001)(6506007)(508600001)(91956017)(9686003)(64756008)(76116006)(5660300002)(52536014)(55016003)(66946007)(186003)(26005)(41300700001)(66446008)(122000001)(38070700005)(8936002)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?y4y0znqnGO8nNdQehDc6saDN0garOMyeEXi7KLcEQ2VYxGEzqCb8gOtT2R?=
 =?iso-8859-1?Q?sg/q1oHPZ1zVvkxEGkf/GKIL1GZmwgPKJJWE7tR18I/E/Hgc7oQ3hjG9U+?=
 =?iso-8859-1?Q?d2L3Z/G1Ol8TvaTRX4GOQc797wJsV7S7kLc55qql8mjsek/tCNobz37yKm?=
 =?iso-8859-1?Q?Js2tTYaFWsl9j7q+1r5tdxmRv4Wx0wY4kfNvZOOp9IMVGs4yeYimeu8sqO?=
 =?iso-8859-1?Q?DemGRo3dvg+0dLR36s1Nkv7RNndFxOjo3fuNLPn1VQGSq7iNaUsVcwYj9t?=
 =?iso-8859-1?Q?/NRj8QaxVoxOTK5pCkkyZdR4oTpxV78jJhGsz13FQgCGkcy2hVQSqc2yns?=
 =?iso-8859-1?Q?yVpXtj8/CaycBX/miUwU1crW03RCnMY3jI5dgu7lkRDnsX5y1158DZ255h?=
 =?iso-8859-1?Q?CrNqPur7am1DhKqn9G3NiZsVHhU9gMZLeNZ2K6Z0Z8n7WnH3qqgI4AUlZq?=
 =?iso-8859-1?Q?+O73zUeDcKz12hPAOEkoqVUP5aBWl7NL3gN+Axvp0LJKatxZjWU3SWOjqm?=
 =?iso-8859-1?Q?L6th6TpBiZaV5c1T7UKj1UIhUIRt0DgWAp9+QO83PhUzUtA8NJqQXq6KE0?=
 =?iso-8859-1?Q?aomyApuWXsQh7W71zjxI/ATevxD/geU/3xEZr3zflqDN/Z89TV8aLajNIu?=
 =?iso-8859-1?Q?CAfQbR2BdGSFiRxqNz5CfRWMO2ifnzwLsvuPP5VeK+lEhruJ2orux/SbKj?=
 =?iso-8859-1?Q?Q0i36RVQQyoUpMCyXM2FnyjOsynbWq0wD1+hn4eofs6xlQFshcZIq5MqNO?=
 =?iso-8859-1?Q?8lxlaNtVoGnIzpmuxqhZvZMxNNhixf+rleZTJrSk5cCbxoPDHphqzY1fy0?=
 =?iso-8859-1?Q?USdpc1DYRvc2Zijz9Fnz6WXfZYolTMgGyKP2CIgDcP8An17//Gb2Mc2Ohr?=
 =?iso-8859-1?Q?kbX1nuJvKfS1pPCKV3uhWUvN7NKfhNbTLahJziWHIm1WhVV2U+4XO+i7i7?=
 =?iso-8859-1?Q?cOzpdyUl6aZFJAVjvx/KbhV5aZ3MLUZtpHcf2XPtl8GeoFj4Nbk65iXATL?=
 =?iso-8859-1?Q?Mz9eH7a74Yf+HZyG0TlZW8lK58vo4TSTghtNwFxkR2pepct7R5UQl8wHS4?=
 =?iso-8859-1?Q?N+As4OY2kDDpSIgC7SrZKHZ+cEg/gtBCh98xPe8+wBQcTImiSd6wKQWGWt?=
 =?iso-8859-1?Q?89MkC5SW3R2oUOnCocRDSOgYapiXQ84X5UvU+Do9tCATpl5s1oijJ5oH35?=
 =?iso-8859-1?Q?CyHeU/3X4dpfVru3LL1gldbymcbmRT7G1Cr65ALrEP/Ge1wDNjxHc6TMvG?=
 =?iso-8859-1?Q?TPoLSsQH5KhBTgeA9PdjJbB5pkyc9xiSH3Q5qy7e/06ga4pfrLZ5CzFxmK?=
 =?iso-8859-1?Q?O+dQHLQ1yuO0YHUfcYKQOii/D6Fd1WdkkRXITEOxuLn/R4DlNpol5GXIr3?=
 =?iso-8859-1?Q?wtAwMCvoNdKssnHMJvhxVoc0t1AWX4IDAHiaYOWkUuEg+bhDmt4ZUuRTTC?=
 =?iso-8859-1?Q?XY4UXx1xPogctyUXu66ckYIjuIM/TiHB9dr48DOEuAerskezLs9O6Y+a9I?=
 =?iso-8859-1?Q?IuFZj70KFOMggaSY28v9BWbP+j09/YXbdjQG3JajGX2xlUbRawGpeh+C+E?=
 =?iso-8859-1?Q?hp4WqqFKU+YtsB0skQ/awfSoxSN0HwX8hBD5tMYdXAYo/33BIjh5Qh7RIN?=
 =?iso-8859-1?Q?TXeIWCJshLrl1/1uyH3HtUlY8VMH4DXhHy/FFPAuMUCL1hbx0hxEP2B7h8?=
 =?iso-8859-1?Q?hokqez+q73hENnuZK1q5R74HSAinB+gKrQAbKOhLY+O0VTfCIBjtnbL/R1?=
 =?iso-8859-1?Q?gKEClqqMw9XJA6THhsvJCeEqvFa/n06QaNiZSIvl3FmhYb9hw+rysIKn+A?=
 =?iso-8859-1?Q?8nur+N3aVw=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digitizethings.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR20MB2055.namprd20.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be15458a-d2ee-48d7-5275-08da395e6495
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2022 06:11:20.2938
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 49c25098-0dfa-426d-808f-510d26537f85
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PGSWoLEB9YuPH093pkXdz4yLljqu+CvUu4tUuN4JFcOz3EgH9A83Ztyu3TXfJOhEFbcNsExTho5Wfg2lmA4CgWO2eiIsjJsmjzytkZblUmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR2001MB1088
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave/Steve,=0A=
=0A=
Thanks for your support....=0A=
=0A=
The Linux kernel is sending the route information with dual gateways proper=
ly to the netlink listener in the vpp stack.=0A=
=0A=
The following parser logic is used in netlink listener to retrieve the two =
gateways in RTA_MULTIPATH attribute=0A=
=0A=
      if (route_attribute->rta_type =3D=3D RTA_MULTIPATH)=0A=
        {=0A=
           printf("AMG - RTA_MULTIPATH\n");=0A=
           /* Get RTA_MULTIPATH data */=0A=
           struct rtnexthop *nhptr =3D (struct rtnexthop*) RTA_DATA(route_a=
ttribute);=0A=
           int rtnhp_len =3D RTA_PAYLOAD(route_attribute);=0A=
           /* Is the message complete? */=0A=
           if (rtnhp_len < (int) sizeof(*nhptr) || =0A=
              nhptr->rtnh_len > rtnhp_len)=0A=
           {=0A=
              continue;=0A=
           }=0A=
           /* Get the size of the attributes */=0A=
           unsigned int attrlen =3D rtnhp_len - sizeof(struct rtnexthop);=
=0A=
           if (attrlen) =0A=
           {=0A=
             /* Retrieve attributes */=0A=
             struct rtattr *attr =3D RTNH_DATA(nhptr);=0A=
			 int len =3D RTA_PAYLOAD(route_attribute);=0A=
			 struct rtnexthop *nh =3D RTA_DATA(route_attribute);=0A=
				 =0A=
			 for(;;)=0A=
		     {=0A=
				 if (len < sizeof(*nh)) =0A=
				 {=0A=
				 	printf("BREAK -attr->rta_len[%u]\n", len);=0A=
					 break;=0A=
				 }=0A=
				 if (nh->rtnh_len > len) =0A=
				 {=0A=
				 	printf("BREAK2 -attr->rta_len[%u]\n", len);=0A=
				    break;=0A=
				 }=0A=
=0A=
                 printf("RTA_MULTIPATH - attr=3D[%p] attr->rta_len=3D[%u]at=
tr->rta_type=3D[%u] DATA=3D[%p]\n", attr, attr->rta_len, attr->rta_type, RT=
A_DATA(attr));=0A=
=0A=
				 if (nh->rtnh_len > sizeof(*nh)) =0A=
				 {=0A=
					unsigned short type;				 =0A=
					unsigned int len_nh=3Dnh->rtnh_len - sizeof(*nh);=0A=
					struct rtattr* attr2=3DRTNH_DATA(nh);=0A=
				    while (RTA_OK(attr2, len_nh)) =0A=
					{=0A=
					    type =3D attr2->rta_type & ~0;=0A=
                        if ((type <=3D RTA_MAX))=0A=
                        {=0A=
                             attr =3D attr2;=0A=
                        }=0A=
						attr2 =3D RTA_NEXT(attr2, len_nh);=0A=
					}=0A=
				 } =0A=
=0A=
                 if (attr->rta_type =3D=3D RTA_GATEWAY) =0A=
                 {=0A=
                     /* Next hops from RTA_MULTIPATH are =0A=
                      * contained in RTA_GATEWAY attributes! =0A=
                      */=0A=
                     inet_ntop(AF_INET, RTA_DATA(attr), gateway_address, si=
zeof(gateway_address)); =0A=
                     printf("GATEWAY: route to destination --> %s/%d proto =
%d and gateway %s\n", destination_address, route_netmask, route_protocol, g=
ateway_address);=0A=
                 }=0A=
				len -=3D NLMSG_ALIGN(nh->rtnh_len);=0A=
				nh =3D RTNH_NEXT(nh);			=0A=
              }=0A=
           }=0A=
         }=0A=
        =
