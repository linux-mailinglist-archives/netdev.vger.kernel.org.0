Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F303448A49E
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 02:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243066AbiAKBAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 20:00:19 -0500
Received: from mail-eopbgr70132.outbound.protection.outlook.com ([40.107.7.132]:4929
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S242528AbiAKBAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 20:00:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CRXMbKWvp2Ns//0CCjHcQ11JvaItL11spSCzOmOJW9WNQaU40APZp3n2pcdm9PmaNTBqpTyYF+mWCLsuzrmOFpLcO23jtTLNpNQWeX1mabhIL2VWN19x5xJKpGlL3X4DUxKthbnK6J//Kc5UI0l+c8nGFIowN5DPb+4fLJ5pkpiSnCO2E9R7Dt8SFy05aF92wrd1wvxjTsZntXEZm0vDmwYOAfRabGXwsaC1nOLf/XVRLhJjaYvQfwc5jP+f082L/a6N/fzP6qSUd6aRpwFeX4iBLZLqkVCr6BseuQTOAC12g+ZyDlfoA+cQpya24LVRas0HhHKv7Ya0n523doyThQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kUlP0g+Djaz3qdbvXxBhPeHubtcghf5+3gPOeViuaO4=;
 b=AzQULQrLWru+vEWBircTcNX13BhqEz7cV5/42695QtxaLF8MfBYoRduqdPsmSl6wKoYju4lK3tTZQX+aTAD0UmRk1OT48RQrpFSgtiaX0EoZslu09yTxJ4QeEkV+gKf/TalO1GxBV2CjbBfPb4er4f+KfOmM8/s26j7lEK9Eg+lBsorv/fTQAW+1eGaMDKNreicBTY4FXswNXe6CLmHriJCGYfjNfYTHh81oOATXQrbDKKVC/+pSgLQzTUqq6GbNaDdrFgiQMYRoGpWRkSvgBoXZMGaoVDr0DMB/mtwtb7PIcObcusVF+lTr4rHGmdNby8WVhaolliIDwmVH0vE/fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUlP0g+Djaz3qdbvXxBhPeHubtcghf5+3gPOeViuaO4=;
 b=CftKW70CpoHNQ5R79yDhwm+JZjDQbloPwNmlB+ggjqUIwEVExrWe2l4NHe81Sqyeic0o8LlRs+L0/uidpy0lW1ORPtDdz6uITV468co86v8U/PqecnHS60iHr1QIM44Dt0Bk/AgBXjaIQmXKv4V7+yjmuWWjbAcxFUfvNsXwxD0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM4P190MB0099.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:63::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Tue, 11 Jan
 2022 01:00:15 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%8]) with mapi id 15.20.4867.012; Tue, 11 Jan 2022
 01:00:15 +0000
Date:   Tue, 11 Jan 2022 03:00:12 +0200
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        stephen@networkplumber.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/6] net: marvell: prestera: Register
 inetaddr stub notifiers
Message-ID: <YdzWnEt4ore0WFVs@yorlov.ow.s>
References: <20211227215233.31220-1-yevhen.orlov@plvision.eu>
 <20211227215233.31220-6-yevhen.orlov@plvision.eu>
 <Yc3DgqvTqHANUQcp@shredder>
 <YdeaoJpSuIzPB/EP@yorlov.ow.s>
 <YdhDZ9Fkkx/moJH5@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YdhDZ9Fkkx/moJH5@lunn.ch>
X-ClientProxiedBy: FR0P281CA0089.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::11) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 362f956a-7fbc-4954-0c71-08d9d49dba69
X-MS-TrafficTypeDiagnostic: AM4P190MB0099:EE_
X-Microsoft-Antispam-PRVS: <AM4P190MB0099076F4E631C856D0AA3BC93519@AM4P190MB0099.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P4ugONrE/3Q+H1XR/prte4G7eN9MuIYhqyklXP4PXwzM0wwMhWeflYDmCn+hnUYm7IJdVIj4SZNETbunFRpirapXNsCbAHWcYJ4JZLxhHdyXRR6M3bxl0fJes4zjS3MT1i+sJauYtYrQP64PERvr1fX6hV5re3vRnQNb+R0Y3spodzMwwu6lADJb+xfR38GCS6shKo79rHWsZveKflUWv/aiEvgo2XEwoV/5NU34fUABXh+rCkPRyg0fNsol9W0HK+Da8LU/5Wk+WlpbdQsLT1DqXeW8MbSIQCU1QuN1zylda3hwKpHmohMB15SHnllXAf2/PUVojWyBeFoUJ7eBt8H3yAvM179sx0xClzrRONP/V5yaQrR0YIEIznMRQzYnyHkFKt3uU5B9r/9DIGcxet/4HPn5219xEq2Lss/OLiKz5Jr/0DtP5dLEGqhCZ4Je/YCPgcQc1dV7aEBCuT0meYMn/HYMydgWzjj/fKtk0RoP4WLIJ1j5lAKeWaSlDYokNOTr/r//5EQQCuCwk8LWwVlFot7y8FFnj2MPOVOGNVs0WGMbov87+MpBEvcihIKI86NX+hxRn4HQTzHo76xmEnq6fZ0dvGqxZTM1tVpjschY3zHxwPGCsqinTqXQyLq9F7e+caQvLkxQuhAEKbxPSQK33vPLQGAjy62h2hY1bybQwh0TvTzy9/oZaEuQlE7rGGMpRfzRCePaf83CYFrLtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(346002)(39830400003)(136003)(376002)(396003)(52116002)(508600001)(26005)(66946007)(86362001)(316002)(54906003)(4326008)(2906002)(5660300002)(38100700002)(38350700002)(6486002)(6506007)(6916009)(8676002)(44832011)(6666004)(66476007)(186003)(9686003)(66556008)(6512007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnNKV09DQlNuMlFnYkZxZzNLMmtkdjhXV2pXMEtyMjR1dy9kRHpQWDFhanNL?=
 =?utf-8?B?ZVRITmhlczg0dzlHZDhnenRtNzh2Wnl6MzNjeFVVVFB2WnROQ0pabVpNU2dG?=
 =?utf-8?B?N0hzZU5lcWwvb3UweFVEd2NTaGJsYkVEdnlYbUNPOGxlalJaWlJZVi9pYWVn?=
 =?utf-8?B?VXM4U2R6RVQ0bjR2Yk95Ri90Z3o2dDlvZUxZMHI1NmprdmgwS3FyM2loOFFF?=
 =?utf-8?B?Q0hPL0YxeFJ5UGlCS3ZYWDNpWjhBYVRzRkE3VmJmRFFmdDcwYW0zVlNYKzd4?=
 =?utf-8?B?QkZkZ1NvNjNXMG9veS9ndVJHZ3RLU0hBd0pGVnNxVWQ3aGc2d1d4cTkxc0Jk?=
 =?utf-8?B?YlpGR0VneDV1M1VKTFpML3dwVXROK1hUWStmbGhjYlNxMDR6aUJNN0ZQOUxi?=
 =?utf-8?B?R3k5MDlsWXA2Szd1VHR4QitMcFFidStrSlRBVXVPa2phZmZBRDVYMnhHT3da?=
 =?utf-8?B?ZDhOVkdzTTN3L21ab3pVVEQ0ZE01WGVBaEZVbFppZDBUeEhiZWJiRU9vdis5?=
 =?utf-8?B?bmtUT3dSbFVSRUN3Z2pEcTFlV29BbTY2b0pwQWhpbkNCeURvVDhsRFNtNmdE?=
 =?utf-8?B?cW1kMi8vT2pOVUU2bjRCVTk2bjB4WmcrSnBaMlVrMzhXVUgxLzZvNFlPMVgv?=
 =?utf-8?B?eC8va3dyc1BFNSt6c0lQMDIrNnJIelgxNVZyUXowVTBOa2JlY0EvZjN0NXN4?=
 =?utf-8?B?SnJ2UUtUeFNwdXFyeWFBUGtxZlJZa2dEQTZQeGpTcnRteVkvaUdwZ3hBMEQv?=
 =?utf-8?B?UUk1RVk0VkFyQ2ZEbE5XdzgweUZYTE1tWWhZTW5jODFmM21ueTcvbENTa0cy?=
 =?utf-8?B?Y3pXamNXa2pKL1NOL1J0YjVtRHlNT2RxaUFpeVdyaUpSZExpVEV1MmJvS210?=
 =?utf-8?B?RTJvYkExRG1uWUNkaEZ6K1J2TFAybEZzV2J2bHByWUFDL3ZYcnBxTU5DK0FT?=
 =?utf-8?B?V2NPYnpKazQ2eHpOUXkzN21YN3pEckNLOHhnS205NlVza3hVdjZnTTk0ZEhz?=
 =?utf-8?B?UXllYzVISHpQSUlQemxuNSt1aU9ucXBpcXN4VmZnYXpKUmJQMzZ4YTJlckVH?=
 =?utf-8?B?R0VxY3dOL0lVemN5SzVGQ01qNEhUNnc5UHlZamNHTkxFazNPNGV5VDZnYjBl?=
 =?utf-8?B?eGVSTzBsMjJYNUtyeU1wUUxBbXc5RUZaL0FESjFCbzdrMFN6bGNiWE9JcElr?=
 =?utf-8?B?czZhYjVUa0VwVmdZMkFIZzQraUtheHFqR3ZyQVVhSWtkeGhWVnRZZ1RFMlpN?=
 =?utf-8?B?dzF2RlRxK0lDN3I4ZmlNakpxTzBsM1RXbEVPYXF6Zm5lWlRtdTRXeWJaN1lP?=
 =?utf-8?B?a0QzNXRiZ1Y3eER2aHZwQndQaTFtMkZjTmROZEJTdVNsOFMrYlplSHRjYXpP?=
 =?utf-8?B?Vk1oNGNmWGQxTVV6M21wekQvSSt6dStkU05tcStzcjhiOTBTSkZMU3B0RXNz?=
 =?utf-8?B?bysvcmRtdlRVVzMxeVcwUUNyUU1KYkZ2UG9YLytCa1lYSVdma2g3RlNYUkg4?=
 =?utf-8?B?bzg1TlFURDJMOTZJT0FJelE0M2d0R1gvbjBBcWZPMzU2dDN3RVh5TGd5Rm1l?=
 =?utf-8?B?c0dQN3ZLSlVEdjhUc1oxSGFsSkd1b2hSVC9kZUFmcUsyOENUMjFSVldBNEhZ?=
 =?utf-8?B?VU9oZWZBVzVNUlZ3dyt6TEFadHFSV0s0NFFscGFWekNVd2NzTHpkb1FtWER2?=
 =?utf-8?B?dzNURnBlZG52UGd3ZGpJRkVDekJsZGhTOHRYeTRQSEtJQXpxeXFKNlQxVXk3?=
 =?utf-8?B?NXNPVHVwdTlTYmFwYTFZVVJKNnk2ZWRvMUNIY1BkUmdjZ2o2QnVUc2Z5WVJX?=
 =?utf-8?B?WE4xVGVzVW5PQklDdEU4OXEvSm1KYnpMQTNPVEYxN1paUlBhSXdkVU1kYlp6?=
 =?utf-8?B?MnNkVTFWcVZwZGVySUxHc0VBSThYSjhad3VyVllrdnhIU2xkTnF2MmJJN2xL?=
 =?utf-8?B?RjlDbjhiQWhPbGcwa29TZ0tTemRqaCtIb2VCOUVQTEVMR3BXV0RpYzR1aWFQ?=
 =?utf-8?B?L3IvOGJEWGVwS2pwSHVuNHJkZTBHaXBIb0JxWE1tcC9CdE1aQkJRQThLREwr?=
 =?utf-8?B?bnhVWFREd20xR3dXRGhLUWZLS2RLVEQ4ZTNLc0ZkOTFZcFJzQStISlVzKzBF?=
 =?utf-8?B?eGhrYlBBbGwxVlBSNHpMU1JLN0wrSFkrSGFWb1lUMnM5RUV0SndGSjA4L05B?=
 =?utf-8?B?cHkwNkZhYjNkNmVjSGRjQU0wcTlCZUxJNXNmZnhGYWxyK2FyWjQzbkd6cGJl?=
 =?utf-8?B?TE91cXNKVURqS0hZSlNhbkRxSG1BPT0=?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 362f956a-7fbc-4954-0c71-08d9d49dba69
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2022 01:00:15.4848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YuMMjc6D3tC1owgUc98odaW5Qvl1P84TCHWucElYYaoU1KY8dbonplyyx/OZj5QMGl+V/HLRH/vXgCvm0f8l0B8fjrkYIVvAvTO+VSF+WS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 07, 2022 at 02:43:03PM +0100, Andrew Lunn wrote:
> On Fri, Jan 07, 2022 at 03:42:56AM +0200, Yevhen Orlov wrote:
> > On Thu, Dec 30, 2021 at 04:34:42PM +0200, Ido Schimmel wrote:
> > >
> > > What happens to that RIF when the port is linked to a bridge or unlinked
> > > from one?
> > >
> > 
> > We doesn't support any "RIF with bridge" scenario for now.
> > This restriction mentioned in cover latter.
> 
> I did not look at the code. Does it return -EOPNOTSUPP? And then
> bridging is performed by the host in software?
> 

Perhaps this is what you looking for:
> static int __prestera_inetaddr_event(struct prestera_switch *sw,
>                                 ┆    struct net_device *dev,
>                                 ┆    unsigned long event,
>                                 ┆    struct netlink_ext_ack *extack)
> {
>         if (!prestera_netdev_check(dev) || netif_is_bridge_port(dev) ||
>             netif_is_lag_port(dev) || netif_is_ovs_port(dev))
>                 return 0;

We just do nothing for bridge port.
Note: we cannot return ENOTSUPP here, because this will make
impossible to add address on bridge interface at all.
