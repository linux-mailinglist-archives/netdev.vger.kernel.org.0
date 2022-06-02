Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9364953B860
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 13:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbiFBL4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 07:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbiFBL4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 07:56:10 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2046.outbound.protection.outlook.com [40.107.92.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C15123F228;
        Thu,  2 Jun 2022 04:56:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RulL7o6amVZgW6ck99X6490lKhfjJMNLvffPVXcqS9fw46aBjJnYTeYnzPJChBOT6J1IJ13krYebJ3Ds+RzLlMRk9ac2+qoo1fKZEg8o/ZWY/DvfJZqEpXzrJhjbenzQK3qfX8urDQu++I2fo00+V8IMKSA77VJmyEIOERqpR1ttk9scfVrnMNTX5f5pQD5WVT4f7tKdA8NXOb1Oj27CBT1o1okFQneUFAWTv8DFLdchEQUZNFvItq3CIT+bTUUfUu+qiUzPvzHlSIPERLSfDrAej5ZjgfB++l8KrG/B8jNIddR4Fk9dxFhtq/+ELMv5TDJ75ZsFx65lnOfVMaHBTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zvSoxtoc+URXndjam79/h94i4YQJxQyRHjhboc0kSkA=;
 b=EbHEqwCGn9ltIFTgWOZ+Du2vjev54ZCN8x3ac+sLva+KhPFcdxJ4syk+mhd9Ai21phtdLs5lh/bFvga3Ylt1fEiNnhu/Xp00PUw14Pr1/I6m7pTeRjKkSpa0+nuhvIiYpztcJolB5pPuJT5LkwZGYn6iH9zG11Gu1KEfkgQ2fyJG68MGo7he/+hrFm5l8AybEgUjY77zosnf+HW3oRO/DGl0BmBPTBhMg1pZu1VcU0ncaOh8cOu/yT11CNQ7LeG/W+uJKn38cRlDOpZvwzC+u4DqtFcTMvJU9jkK3AE6/w8BhtK6gfQ5mQGZ1DgRJTIg+bFWke7kmwVAz13wbRQW2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvSoxtoc+URXndjam79/h94i4YQJxQyRHjhboc0kSkA=;
 b=l3o5QBkH/BN8PeT6jlePr142EEy82unzW2ShOmo0ZN6cXsg6EXPNtInyqlBGFU+V6Jct03my19l2lieQjlWbproznVxiow97IcQz0kjoaJrEAzO4xADPmPo9i9jf13wqpfi6LaQhx7wPRDlYYsKaHOfCUH82/XiWBJFrgdWyjae26kOkcNl0p8c+h/784uE4lAqF/0CDVBaR54xvfMl0CR4SZPCOdPbOW3xphKZ4SPWNlejFBNmLUv9GDVZmzuGyhEFWFraIMcslM3gkYOLG+JOvh0Se6Htqs9UU2wuxcnwz5dLawlKegNpJt7CHGtWCnCV2qow6z8eNohn9MME3EA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MWHPR12MB1327.namprd12.prod.outlook.com (2603:10b6:300:11::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.16; Thu, 2 Jun
 2022 11:56:02 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::99d2:88e0:a9ae:8099%2]) with mapi id 15.20.5314.012; Thu, 2 Jun 2022
 11:56:02 +0000
Date:   Thu, 2 Jun 2022 14:55:55 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>,
        Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Message-ID: <YpilSyiS/1vAbauA@shredder>
References: <86sfov2w8k.fsf@gmail.com>
 <YpCgxtJf9Qe7fTFd@shredder>
 <86sfoqgi5e.fsf@gmail.com>
 <YpYk4EIeH6sdRl+1@shredder>
 <86y1yfzap3.fsf@gmail.com>
 <d88b6090-2ac8-0664-0e38-bb2860be7f6e@blackwall.org>
 <86sfonjroi.fsf@gmail.com>
 <3d93d46d-c484-da0a-c12c-80e83eba31c9@blackwall.org>
 <YpiTbOsh0HBMwiTE@shredder>
 <86pmjrjnzb.fsf@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86pmjrjnzb.fsf@gmail.com>
X-ClientProxiedBy: VI1PR0701CA0049.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::11) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b31a42d3-0019-4589-f1f9-08da448eddd6
X-MS-TrafficTypeDiagnostic: MWHPR12MB1327:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1327630A0A4AB184AE0254E3B2DE9@MWHPR12MB1327.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VLuqme95nE49Fsx3w0TiOeZaTEf2jKACKPc4QrLHmiE6WlSMIIP1qdX8fRy+DBs+6n1m2i2pguIz9K4K0/0iRk1cXzRmtkh5OyghLryRiXQ8MO/opgEcm6mdc5xc3uyeW/UcCevTDyhZgg9i9R+ONP9vcexeE02vEdztaC1fsRYr22L/h3b/m5470Y4RVDp9G1XqUQ2Di0wzOaGDcgd4k/dSjFL37abZcc9pyGoqy/bhPPt6Dv4ZgDdoVhnLWx2LU2qMKfcV5tfG59ebWFA/QPHnKjRzYXjoc90pZnWwuEgxA3u8CagLjauMl9vz4aX5N64gQT/YW1j0NxH/MCDVgx+mtey5t9uovnhPUQJUgG1kiUQJpAY9l7zlfiaY336OaPZDH/PlWo8wrYQb3zeEPbVugTg5wBEJIj304bFRZDUkBDy/LCvrKew1fa41nVp0ALvAc8mWC/NjoJZMXBt6RtljVFMZFfg8oUyHZ5APeDuvAB7PEfT9rNGKMRBZhlhFAzU7HaKopaCir8CYYsUwuPMOxuKO0Oz8bbcLeThmNUW9FqvKVBL5OIkWIVW5fR3c82R1saG6w88ZlzAD5uXgLMmUfHrzECCM1qjUqUnnaRwjulHznYexzXa4mDzR8CqJ0yk5xPtjr16qoMjFi4sQRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(316002)(66946007)(2906002)(66476007)(26005)(38100700002)(66556008)(8676002)(4326008)(6666004)(7416002)(5660300002)(83380400001)(9686003)(6506007)(86362001)(53546011)(186003)(508600001)(6486002)(6512007)(8936002)(33716001)(54906003)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jTbJQFwbj0+2D5VAMVZ1F4X1ILT7kTeBZ1hRBG1PCmMzYZxvA3Yn/9LCoCsI?=
 =?us-ascii?Q?xs+D5WaYPmnuPXrFQFISkH1EQOtzL/qm2vJMkxcxTAH8/7c7SmaKQ7KdQkG1?=
 =?us-ascii?Q?gGYQ6atMOiqXU12d3hHw3klVsUlOltXdbPyzz4oQPoXkxVs4VrZeLQrJSqNw?=
 =?us-ascii?Q?F6CoryD5aoilJDRF3+2gUIYs4/UwlgwWC7xBFhLvY44Y5bU6TjTlsZ0D1Mxx?=
 =?us-ascii?Q?iP6E19MbxKfXvWdQR8dtC74fPiUeOBrxJfldstK09TeFDBbCm1OBZBhfds8h?=
 =?us-ascii?Q?QkboD7VBCPCgmtK1TbaFihbuxJFLFrjggtDMjd9S7MNp4zP3VFfFOOZZeVRy?=
 =?us-ascii?Q?FdiKXf8w46dP8ww5JZRM9ortXpIlvnmUD3Jr/7TZECZ9x+zgvKlLVQmuZxYH?=
 =?us-ascii?Q?yQSCIuMzFDREevPwRAHAfa4wadTy7djxnAH83leUa8OdRkPkm4RbyKLkFLE5?=
 =?us-ascii?Q?Objnb/MbdkVuN7ItcAfyZAlTeSyb/z58qsM0RRfhnLrrYfxvopwWExEkc3x3?=
 =?us-ascii?Q?iHC+01IwPG8vN4v9AB+CqCrB0diAvmTHvP4RC1+3TiHYaGAa8NLuAv7aBh90?=
 =?us-ascii?Q?CNIZdSZGdqp6GZH4vFpoqdiMcMcUvEsSgIUrP+u0lfzdkg1Rfa4YRmhNZ7rs?=
 =?us-ascii?Q?O7Vpt3ugcLJLy5xk2zSBmgCMj/PZuHFCkMBoUf/hz8NRsquTpVJAyUmk1Gv6?=
 =?us-ascii?Q?UZTZb/rYdfFjNk65suCah3IVEWBYgCdy1xR/JcFLAVFJDOcLVzpMtdF69U3K?=
 =?us-ascii?Q?6f+cVsNhoE+h1cFVLhICVDiWUAobkKlbQMiFMa3bor1rHAKxrCuVvfL2yR20?=
 =?us-ascii?Q?g7RqT787R2j9asB98CcXhARj3a8OZXrY3fcO5E0Apqmm5NzzWdOpFs2Hv+DB?=
 =?us-ascii?Q?TJTP2LVOn2GTIQ7Ioug9Vq7Go4c15E06+OwjGxR1fM0GEx7Vx0XrRn+YRlsd?=
 =?us-ascii?Q?KtI6ENxmkivVT+msLd6rHGDfjzG7DzRJtQjpnbQqx5UmSsx84WnUCtp2FfRG?=
 =?us-ascii?Q?c718nLVmCoEC+Ee21idEZkdya0YOr1viwEvAPwQFBUWvxIgVQ+wuoDUpeEOW?=
 =?us-ascii?Q?rg6xHtcLEiPTwj0b76qsGwvv41BhLtkSVhwAZEFj/AMKZkIMuuivP6BYHGXJ?=
 =?us-ascii?Q?nHOlDdZ05vpaoswAj5ETvPDVb287PpjS5fRMUOPiLz9ai/uCio463Dx+OLxW?=
 =?us-ascii?Q?m9Scqy29EGAjWVA/YvTqSkK1YC87px+7F3v4eYVvG+1sj10AianN3844CA7R?=
 =?us-ascii?Q?1420tlO9IP9GAKyo+c8KojySYvsiL5M1uJZLopwMugJ44Wogg8DXg5VqCJcQ?=
 =?us-ascii?Q?u41inSN8MwSvw6VFMeeozaqD4ob5JSD5Iv9tKSzZzhrTCr5lPezexysq/oLc?=
 =?us-ascii?Q?cpyatwej/s4stlzZsJjR97PXUUT62bfR4ypiYJRMP0hXSWOXEMXUr3LDviZ+?=
 =?us-ascii?Q?z1f3uAV2ktlnLLDt4gmElq8EDsiCuyeNWabkeg0FIFNIs53AHHenKLBzmVd4?=
 =?us-ascii?Q?soNGj4wqPT7Wie+11TfJHx1YzK3Aj1KnXJlQChKrPE3XMwcElVnVRuaPc87f?=
 =?us-ascii?Q?53OXex2jKfyJADILLQFSsyHHiCeKZ/AdKeUW3Sn5+UBYaFiddKbtvAX7zGXJ?=
 =?us-ascii?Q?WUDVLbyQCV6x/mnXiLrQ1wFCNXy+Rz29OZ6lA4lXCe++f28xYrHTdGNadzBC?=
 =?us-ascii?Q?3rDy7gaUHIuSM2M9mmAH3L9OkKhGG5AyOjbvEsDbe2gFMWNCk4yIzJRUIDCP?=
 =?us-ascii?Q?E+8XRcknIQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b31a42d3-0019-4589-f1f9-08da448eddd6
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2022 11:56:02.5648
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F4+Zojb3HkWNpXU+ZC6yG1abO9Fd3h7HaU6p2CvjbRju/ZbGPICxlzHfXRwDIDdVAuTJAMNv83fbJ5z2TiBt+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1327
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 02, 2022 at 01:36:56PM +0200, Hans Schultz wrote:
> On tor, jun 02, 2022 at 13:39, Ido Schimmel <idosch@nvidia.com> wrote:
> > On Thu, Jun 02, 2022 at 01:30:06PM +0300, Nikolay Aleksandrov wrote:
> >> On 02/06/2022 13:17, Hans Schultz wrote:
> >> > On tor, jun 02, 2022 at 12:33, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> >> >> On 02/06/2022 12:17, Hans Schultz wrote:
> >> >>> On tis, maj 31, 2022 at 17:23, Ido Schimmel <idosch@nvidia.com> wrote:
> >> >>>> On Tue, May 31, 2022 at 11:34:21AM +0200, Hans Schultz wrote:
> >> > 
> >> >>> Another issue is that
> >> >>> bridge fdb add MAC dev DEV master static
> >> >>> seems to add the entry with the SELF flag set, which I don't think is
> >> >>> what we would want it to do or?
> >> >>
> >> >> I don't see such thing (hacked iproute2 to print the flags before cmd):
> >> >> $ bridge fdb add 00:11:22:33:44:55 dev vnet110 master static
> >> >> flags 0x4
> >> >>
> >> >> 0x4 = NTF_MASTER only
> >> >>
> >> > 
> >> > I also get 0x4 from iproute2, but I still get SELF entries when I look
> >> > with:
> >> > bridge fdb show dev DEV
> >> > 
> >> 
> >> after the above add:
> >> $ bridge fdb show dev vnet110 | grep 00:11
> >> 00:11:22:33:44:55 master virbr0 static
> 
> >
> > I think Hans is testing with mv88e6xxx which dumps entries directly from
> > HW via ndo_fdb_dump(). See dsa_slave_port_fdb_do_dump() which sets
> > NTF_SELF.
> >
> > Hans, are you seeing the entry twice? Once with 'master' and once with
> > 'self'?
> >
> 
> Well yes, but I get some additional entries with 'self' for different
> vlans. So from clean adding a random fdb entry I get 4 entries on the
> port, 2 with 'master' and two with 'self'.
> It looks like this:
> 
> # bridge fdb add  00:22:33:44:55:66 dev eth6 master static
> # bridge fdb show dev eth6 | grep 55
> 00:22:33:44:55:66 vlan 1 master br0 offload static
> 00:22:33:44:55:66 master br0 offload static

These two entries are added by the bridge driver ('master' is set). You
get two entries because you didn't specify a VLAN, so one entry is
installed with VLAN 0 (no VLAN) and the second is installed because VLAN
1 is configured on eth6.

> 00:22:33:44:55:66 vlan 1 self static

This entry is from the HW. It corresponds to the first entry above.

> 00:22:33:44:55:66 vlan 4095 self static

I assume you are using VLAN 4095 for untagged traffic, so this entry
probably corresponds to the second entry above.

> 
> If I do a replace of a locked entry I only get one with the 'self' flag.

IIUC, your driver is adding the entry to the bridge and with a specific
VLAN. So you have one entry reported by the bridge driver and a
corresponding entry in HW.
