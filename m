Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629DE5A0E8A
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 12:56:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241380AbiHYKzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 06:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236135AbiHYKzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 06:55:36 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2063.outbound.protection.outlook.com [40.107.22.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48170A3D2B;
        Thu, 25 Aug 2022 03:55:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3tm/nsiRqQ6BfmJmOq4oxEobNpq7SqiwEiTMeIgIwsWTXxgqxevB1x1d/6xlFEjbwiYWvh2sQGT0ZUxMxlgBdhp5PeKItauraMJsKcseiUbbND3iakyRgXXP9MJV7hS5AysfQC2xtzEv4Irm+hpTyG3AIu5KsDoFYhNYlN6hHBHQHkozBOY5KQFl+0pn6aI1NkfAzDOsSmsTPShwqVJ1P2fcECuLBRNfRh1xhD+HwJwS2egnUlWbmgG+ZokiLjRyoqOMGFNc7RPZ4rjq5E/UO4fs1e7jbc48hL4V54Y2WvapNPR2RcBeNffp0QqUwUqjqY3Iaj66omUiL/h21HZ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ff2nsWCx6OJlh2WHUi12/wcg2z/ba+eD553+jjjXuLo=;
 b=LXEox0H3wj/JUuW8Xvbg+J3Twx+vfBt6cBZtKVtFdMW+tnKmL4zLk7TSVgdSuoGIcuabCcWb4aSlb7TFHyUh8fpRBe9C0ENKQM4cMVI5axxcib3R1iUhOj4OfPPTep4dtOR2bbnfFvqsZZNCmGBCkLmuuUwVtloCKow1CeFUoMVdg4ltLRqgP8XQ9reTKDN+Rip4pnC/y6O6lsiaOESdWIVPV5WsHQri4/DwcUt4zi5g50yzRLI6XTPEHb8/VQ+/fg17dUBU5z0uuoSmVDa8cWuF1el/qYBj5ItBJ4Re9nxaoW7xTm4SGdHiOSGIajKG199oxBw0bvm+FwG85I2PYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from HE1PR0102MB3163.eurprd01.prod.exchangelabs.com
 (2603:10a6:7:82::31) by DB7PR01MB4267.eurprd01.prod.exchangelabs.com
 (2603:10a6:5:2d::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.15; Thu, 25 Aug
 2022 10:55:30 +0000
Received: from HE1PR0102MB3163.eurprd01.prod.exchangelabs.com
 ([fe80::8c76:f512:a793:bd5]) by
 HE1PR0102MB3163.eurprd01.prod.exchangelabs.com ([fe80::8c76:f512:a793:bd5%3])
 with mapi id 15.20.5546.018; Thu, 25 Aug 2022 10:55:30 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     kuba@kernel.org
Cc:     andrei.tachici@stud.acs.upb.ro, andrew@lunn.ch,
        davem@davemloft.net, devicetree@vger.kernel.org,
        edumazet@google.com, hkallweit1@gmail.com, joel@jms.id.au,
        krzysztof.kozlowski+dt@linaro.org, l.stelmach@samsung.com,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        vegard.nossum@oracle.com, vladimir.oltean@nxp.com
Subject: Re: [net-next v5 2/3] net: ethernet: adi: Add ADIN1110 support
Date:   Thu, 25 Aug 2022 13:55:17 +0300
Message-Id: <20220825105517.19301-1-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220823160241.36bc2480@kernel.org>
References: <20220823160241.36bc2480@kernel.org>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: BEXP281CA0009.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::19)
 To HE1PR0102MB3163.eurprd01.prod.exchangelabs.com (2603:10a6:7:82::31)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b346e61e-7ed1-4b0b-4309-08da8688539b
X-MS-TrafficTypeDiagnostic: DB7PR01MB4267:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6NHMpP0P8sL/7n7HYWF8+u8tAHsxpHXu+ogsFM9cIdRQeruj/x5HdvqhHb4Ynp3tAQBLjMFmMHiJBBPkpVm60rJNAtVPLHsuDTydocGvbn9oZXqClGCh0uPfblWtwKiuZggMUhd3ZiDSVUgLlJ7UmA1sivt9edb3ATfoPbt+NI2wpxrU3A6dfXVu72ypLCA265dJKlcUqGX373uN56jCMsVYcRUOPvvsE9rZIEIZRE3NWM3I8RzIHJ7xeECtTAmrP/WcoGcyutwEu+xHNUyrLIYXM3+vRkqcki3Ig1cb7UNj8sPKK1Z4O7PPgnoC0It+aaZC8iMGmuVFvdV9k7P0+r0Q5lE1VsjjNKSa0/uzar9H2oX8N9WEl2CzIgf5oJy8SLetMCOe9H7SljurcGh3yYCfsk5UHyrf2TlgspW6AlWpzeLQQIcQUHI19eUyKFE9Ie/XyQo68w566ufwBA2ctJEYN/9bl1vEMIrDRzjK1DfH1ILyZrYFx6xBgvQmO/GrcFxr2vmK6g6iYqwKx7qn0C+6M5j1RQPDPybSk8wm3IkNMp5fPjgkcflISF19TEsov1Skj5gtNT+gE9CFvkMNjeMY8tFxwT/mCbwzstuwSLcQToREHa1DxeMab2QYLS8ugGxOhkY43R8g8pNAh1Y3lefhlY6SR+XOL3bnrUpivKJe+io0oXWydi6H5iXwam0f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0102MB3163.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39860400002)(346002)(366004)(5660300002)(7416002)(8936002)(41300700001)(38100700002)(478600001)(6486002)(9686003)(6666004)(52116002)(6506007)(6512007)(2906002)(86362001)(186003)(1076003)(2616005)(66476007)(66556008)(66946007)(41320700001)(8676002)(4326008)(83380400001)(316002)(786003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aM7eScm+6g/4zBBjdITBgQz2LksfyyfGRrV/tpV3y5TxeMSHCGatkUpwO/JZ?=
 =?us-ascii?Q?FKja+9wItLXd7m7YWfNd+kDqnTlFRnKPF28koiy+JfI8HK+f1wQ8bkZeA6C9?=
 =?us-ascii?Q?4zA/L78AsaMAwIGCAk0RUY20LT6NvjWl7eUgiAkqAHrZg9GsoqPW4sEcBvBh?=
 =?us-ascii?Q?NeeqxXRLN6TvPCukYPRv3HKLw/Uviu+Q4sR4jSKmrEVZNr9RUH54fUMdRX+9?=
 =?us-ascii?Q?JEhkwhCFwVxCxjl4pO63Hl1N/w6QcQoAuwhsckOEl5YsufF/QnOxRtYAiKV+?=
 =?us-ascii?Q?zkotYRB9MV6oR1zJs/XT55X5tuSQ8wFObTZ64iDC4DhN0E9ArAbqIF7obJe+?=
 =?us-ascii?Q?NAOCdZ2FoUkwDq4r6yjWXC0fhJK25vqqNIi4pWx3nSR8ngzY0xNmdkYk3MDE?=
 =?us-ascii?Q?JKakAx2p+7w/I8oup6QNixx/D3f0euGLF/IEGxbYTO11D0dBgUlTsvyqqM4R?=
 =?us-ascii?Q?nQSV7eR6P81L0f5Ea6nGO0Lf3AlQwTrPl/Sy5odlbBhXjRI2vkVwdYWGbItr?=
 =?us-ascii?Q?2rDwD10MUQ5bXwkZDWRO/nfDxTlTIGz3yzvUtRdIPoehzE3rwBl7nl1ElHPB?=
 =?us-ascii?Q?8t/P15UaxQ3WJ3T8PafdP03nhlDdmTIm3wrLgcowtxU/a9YqzBZIvnoGrY3L?=
 =?us-ascii?Q?DW1Tg27xW5Sga5ypCJNvL99/vlXtYJrT8Yu1mtEPHMW4MA2LBmOzJsp1gT+I?=
 =?us-ascii?Q?Z/jRkeoIe/yxeMAv9787YEg0t1RCHdxl1hJrp+1Uw0ZjhAvj0GKnJnVyuFLq?=
 =?us-ascii?Q?XND9bHnLbw+g2aWzaBE0vtluNeoTlNWbsnWOozj4bc5J7sJQdziJ4Uxqh+x7?=
 =?us-ascii?Q?DzX5bwtHO0VuK5/+cNN4E3UnZ1HlxPp9C+bUeCAe7054VspMhpgYLjw63R/g?=
 =?us-ascii?Q?GkUvhDnFaBIvxXZdXUI3OojXKnvucXRHl72jqAehjf2SYIXDNiz4cnTt702s?=
 =?us-ascii?Q?3HoX7SiAc7eifhR6eARV7D7XTmXuq57BpbD8YvsvlCpyrlH3dXYiPz+ZvZDm?=
 =?us-ascii?Q?yVWrw3u8aVG9vzjzwjWPq9itEGYQ3SPbsFozXeeSyg0TsYw9oAjy/W70DSS0?=
 =?us-ascii?Q?ryWGsEVmHXIxpBg4Fgt7HwaLP1mhUxVPJ9b0JXt71k2Io3jf+QpS24XtGFd+?=
 =?us-ascii?Q?2HWy7R+8/hCBGyKU+0fLF54mf9r+zSqtGetWJ2yVDcYtScvqkpBE5SfbgL86?=
 =?us-ascii?Q?m1y7ly2YMju+OnMAWbqgdP8ksdtLvogVW33Bu4VPyTRPHe4mSGaE+cT8rJBD?=
 =?us-ascii?Q?QevK0LDDl4vzbooDXqyTmhpaY3mwX67CUDPKXwC7Nr9lQvVkO8xdsnPXqmsO?=
 =?us-ascii?Q?t7lonM69mDGTr8d/53vewOkgH0kGYGmt/8il0Zrgu6CTQKfNJuNRovkc7bp6?=
 =?us-ascii?Q?ThR0n8jDgNQlA9BMU2D/aM5AJ5E9HfsG+L2uTJ4L1/pPMM1Vpgr7Naed2Xb+?=
 =?us-ascii?Q?Ykr0EdSCq11O6j670kJMCawaMInUqQvVLt62bc7fWW3VYa5kDjtXeu6O96i4?=
 =?us-ascii?Q?cYYS2PUW0omb+QwPmhHffkJW+u2/CQTMBhPF8J3F3fENm7OL1x5Re1OFv+4G?=
 =?us-ascii?Q?WPPVnagTLu0PP1417IlVQbcnAN7rtasttorSp6dMB5TAN5JSwwjypi47gIIt?=
 =?us-ascii?Q?Qv9u64ugwEvfiZOK7nyScLrL/+8ThXKYUztBj54GjWJ7SG8VxzYfR84Kbbdo?=
 =?us-ascii?Q?H4Mf8A=3D=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: b346e61e-7ed1-4b0b-4309-08da8688539b
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0102MB3163.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2022 10:55:30.6298
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +BjxU3aMIyp6T+fWw6ftAaismwX/7GWozLs9p0lkqOSw9q5Ppsh6uzzAeErcCZVn1R4VNnSlg7iyq2Pl7A9PP/6FqOSMMLHsdQ60B0HOTYo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR01MB4267
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int adin1110_net_bridge_setlink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags,
> > +				       struct netlink_ext_ack *extack)
> > +{
> > +	struct adin1110_port_priv *port_priv = netdev_priv(dev);
> > +	struct nlattr *br_spec;
> > +	struct nlattr *attr;
> > +	int rem;
> > +
> > +	br_spec = nlmsg_find_attr(nlh, sizeof(struct ifinfomsg), IFLA_AF_SPEC);
> > +	if (!br_spec)
> > +		return -EINVAL;
> > +
> > +	nla_for_each_nested(attr, br_spec, rem) {
> > +		u16 mode;
> > +
> > +		if (nla_type(attr) != IFLA_BRIDGE_MODE)
> > +			continue;
> > +
> > +		if (nla_len(attr) < sizeof(mode))
> > +			return -EINVAL;
> > +
> > +		port_priv->priv->br_mode = nla_get_u16(attr);
> > +		adin1110_set_rx_mode(dev);
> > +		break;
> > +	}
> > +
> > +	return 0;
> > +}
> 
> I thought this is a callback for legacy SR-IOV NICs. What are you using
> it for in a HW device over SPI? :S

Here I wanted to allow the user to change between VEPA/VEB. The ADIN2111 switch
is not VLAN aware and also can't do any meaningful forwarding when multiple
ports from multiple ADIN2111 switches are added to the same software bridge. For these
cases I thought the user would like to disable hardware forwarding (VEB).

Should detect the above cases and automatically disable any forwarding instead?

Hardware forwarding translates to: I don't know this MAC address (not my MAC address)
throw it back to the other port. ADIN2111 can't learn the FDB, although has 16 entries that
can be statically programmed.

Thanks,
Alexandru
