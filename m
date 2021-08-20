Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6C53F3754
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 01:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239686AbhHTXhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 19:37:22 -0400
Received: from mail-bn8nam12on2084.outbound.protection.outlook.com ([40.107.237.84]:59904
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231506AbhHTXhV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 19:37:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UfvV9rTm26eOc+3ndVlrkKLjO9ndqCuaNrnJLuLWNqdPoYy6WoGLrj7brJH25RJRbvgLOUQAu5r+kqcmz0BivIM0S3hVGv01veMPCJmOQuWiifvQwVsOtgWgenP6pKE1CESwHKwSe43edy3BupQPDtVaa6n9wQC2L47sln3YtNbybUDw7Fi7ccLzDos+kowLkwJrGWP3vbVaKpsN3r6d+iBOA+9CdQzW5L9N5BcOBLb+Gt51Q/GH2xAEJFEccL8adqBiUu4mwSn3sGtXSgC5kkbFJjp2jV19or+fRnW/HHhRBToBt1iZWYp6i0dQqUUmmGDAvjAYaMOB4m4pkaxrFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLpUSkN5Ig4o9ZntvE0pKYRjGWGnlFtruc1f7sH5PkA=;
 b=Jkswx5KlrDsTFyWHQ/jPxa8daPqnD3mKYwQ6BiJIZ9+h3EiMkqwK0L55KrapjpMZ5WvZzx1yFUQ8SMCKTzBa2gXF6L2bfChpyx7Si5EeEr9Xs4FB+w35i5um92ahS9MMyDLoEPX+yHT3MWoCZDSNl8xXl8SFiZuO7mh0AyoSg4as5Sc9J3QlzlFb0+CfQ2udiYK/TZHt4lEYYltg6NAsr0r/rC9HYglmr5BbYgyZx+FhLMd6Lb92Rkoxvbyr/vmRM6pxAmp0v9qeEO09Gw9ViHN6fhH7BIEVmTvqyQd4ilBbKkiaxrieAty07iGYiPDfIllf1TlshmyAVw1jsBhaJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xLpUSkN5Ig4o9ZntvE0pKYRjGWGnlFtruc1f7sH5PkA=;
 b=a2+QMLY3TS3Tz5nz8ulrJr36DIQGBQ/7guK27KiI9MpcmMMr2A5etaTHRcCz84hQ7emn8nEja7fXtF0La3DfifPUPrEebPlLO8wwITViJRG4W+AiNJSJG2YSt20ZV2pjYkiuiQplXzeR6CiKHk9Ieyk5T6OZpDKt9BCK+rmwO1si/oUcU7ch9D3em/zbfbpoPT1uXX47FKhhQHyebRDAXfJgG/yIIfs4tJjFJG6PAQK51ExCvCBrOumQsKUIUDsQ8Po5ovnvi5xIv997R0ZW/wrfTnOgYwrbbOcks462AXu6XAguqML/MVEePHNfHjmXre1Z5QqXknC31Mg+Bd/i1A==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5294.namprd12.prod.outlook.com (2603:10b6:5:39e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 23:36:40 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4436.021; Fri, 20 Aug 2021
 23:36:40 +0000
Subject: Re: [PATCH v2 net-next 0/5] Make SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
 blocking
To:     Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
References: <20210819160723.2186424-1-vladimir.oltean@nxp.com>
 <YR9y2nwQWtGTumIS@shredder> <20210820093723.qdvnvdqjda3m52v6@skbuf>
 <YR/TrkbhhN7QpRcQ@shredder> <20210820170639.rvzlh4b6agvrkv2w@skbuf>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <65f3529f-06a3-b782-7436-83e167753609@nvidia.com>
Date:   Sat, 21 Aug 2021 02:36:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <20210820170639.rvzlh4b6agvrkv2w@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0041.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::10) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.240.22] (213.179.129.39) by ZR0P278CA0041.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1d::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 23:36:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 781b26db-6d96-4726-5697-08d964335be0
X-MS-TrafficTypeDiagnostic: DM4PR12MB5294:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB52940C639C6B967C003EAA80DFC19@DM4PR12MB5294.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ggXgieUECQbHYi6Sw/oPqE3ed5+/ND7U6bzHOW5oMHcriIlFqFxEByssnI71cVQ7KWFm8BxgrW3wZSsdHC1m8N40a/v8sVMuKlCq2UZBX2YQoakt3aNsrEnEl7wGkfWFapCiCWV58eD0vQS1nOaYd63w7ROGrltzfIA4Aw/JUMCkOqU9FX/dK2OkShpMkq6Xr/t83ryCOoGJ2R2md4Y6YdeYcp7M+m584TtNB0y03DzwZYKWdDASR8Mzo7Pl6y7RcxsoqGaSKfjq4zuKTLGaznVgM6o6mhx7hn90gOL3T0oDWZsrEoTq7FrQuBsoSyzYF8wa4Uw5FJUnHZM1V3C3Lupah62OibMphdCoS0ScDRn0dHh2YhMLrFdJ7V4fmt/EfaatrBTkkARhXLYG7011ry1yW6ad95rQKFzDRZe9HHwWGd02uCZlIv3eBuvibCQZUSropSmk6SJJFPNH/2G/kjmgGDyJ9XSByJMRCS+l4zlehSlvxgUyvwfsbnnEWSNpkwtaefDZxgsAJyxKvn6phGS+9rExAMQrujtO0MlkhukI8bqiZCrfAF8FhIT2pfXyNPdG+qAE5nGEW08CT7HZCRa5wUELOLov6G1C1t3Xa7y7GIiMsHPF2HFvsHYtiqElO1e97QJLG3guj1jxIiHsjeQGgF1fuQ2JA/san6VCHKw+UmWvOxEdTUpxyhT3JjFkFsKe42Qiw2l4RRV/0nRaLUUo3q9fLxW4Oa3hnaKcAhU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(186003)(8936002)(478600001)(66946007)(66556008)(66476007)(7406005)(6486002)(31696002)(38100700002)(86362001)(36756003)(110136005)(956004)(2616005)(83380400001)(6666004)(8676002)(54906003)(31686004)(7416002)(26005)(316002)(4326008)(16576012)(5660300002)(53546011)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MEU5NWtRQ1VxSXZZNHJSY1U1VDJHU3F1bGU1UnczekNzWVZ4b2FVYmRQVkxX?=
 =?utf-8?B?VmxneThwSkJsR2JzMGlZelF0VlFNU2F3MmFQTUJrQjZwWHZNRWtQenlPOUdT?=
 =?utf-8?B?NENVSzlqcDNGaEE5bzlBQ0p4b3VkNmtBQmdzZVhCNzdPNXdLdmZ2Z3kxbUpJ?=
 =?utf-8?B?bU4yYlBQTEY5UlJnTGxwWHU3VmI1MFNHeTRwL0JSbmpDUklLajlNTXB4Nm9B?=
 =?utf-8?B?K21hS1h5RThUcnpxVldkcTNNa3ZCQWl4a2xra09oR29Oa3hLaWxQOUkvWEJU?=
 =?utf-8?B?Rk9vSWpVa1N0NTAvMkJLSEFiUTJXNHR1QWNKZDdmY1A3VUZPcWdaTDNnZElT?=
 =?utf-8?B?Y0o4VktVa2ErdGhTaTRzOGNwZU5LU2xsMFdtTFFKZ25YVFVCWDE5aGR3Q3Bk?=
 =?utf-8?B?S0MzdklXekJETnpsejh1MkRKYjg1L1BlV2dZQ0JjR3EwbFhvaG1UT3I1dzJN?=
 =?utf-8?B?TjFtVk1zWXdMUVdhUHEvYWRDbmYwVFBmd1hyR2F0REg2WWpFYlhjMURNc1dX?=
 =?utf-8?B?NWJOL1RKNFVtMDRmRzAxb1JacXRrN3R5MGJ0NDNGYnhsUG1CM2UydHZMUzRi?=
 =?utf-8?B?Z01kNVh4a3NqbjNFY2xydVc3MXRzOHlpVjZpMVdLZm9TVm1yd2grOVhoMjlC?=
 =?utf-8?B?blRtWVZoeXRvNno3dXBRdEY0ZTVTZHNINkYyb2VmRXU4VG1LTHBXUi9UK2Fa?=
 =?utf-8?B?VGF0cGt4TVZuR1lPYm1uOGYxTkxMZ0gxY2tvUC9hRjgwbGF1NUdGdC83WDZW?=
 =?utf-8?B?NllpZXByTmJHRlFjZ1ltMndYbDFObFFQMVlFTXVNVVJ4M2NKZ3JMUG1rQUh0?=
 =?utf-8?B?czJwRzBTYmxhRTFZY3FsQlpHaUlpMEpWS05CSythVENxUzBlM05aclhRMFZk?=
 =?utf-8?B?SFlobWZTTEl0b25hZUUxTWg4VXFJSnkwZHdJektldHdDV2JkM0JzZ2tXanJU?=
 =?utf-8?B?WnEwR1RQN3pQOFZjTm9KRWh0NlFxR1J0Tmc3M01QbmdFY20vb0kvM014MGlm?=
 =?utf-8?B?RHFidEJJa1EvbVJaRXRwNDRzdk9PUUN3bDE5TnQ4cHJDaUJqY3N0VEtOci8x?=
 =?utf-8?B?bWE4dUdSNEg0bnhPWDNUQ0FFNisrazVqOVh1QkN2Skx5Z2RFcmw0Nm1ZYjV4?=
 =?utf-8?B?T2dmaVNDbGE3ZkQzQjRLN2plcDlRUGk1aGFUc0JKa0Q2U01idVpXbzBOMlFJ?=
 =?utf-8?B?MXArS0s5NERTaEpidVBnb0RzeVVsRUYycWNMVVZjYTd5ZGIzMzBZWXI2RkEz?=
 =?utf-8?B?aXlPTmxEMHRON0QvMkxGQnRVREhWQlVtN0kzYTVNTytkNmVBVUZSNEVldWI0?=
 =?utf-8?B?VjVTYlkraEs3U05UZXpzandBQk5YWDZDWWlIMWhKUEc1ZkNFQlYvRHRKUzVE?=
 =?utf-8?B?R2Vkd05SZ00xenJ4bFh2L2NUUldWY1hMWDlNcFVtQ2ZRMjdzOWhjUkNkN3Jq?=
 =?utf-8?B?K1hHQWdrdWI3VWtTdnl0ZTlhTHdoLzd5YWFTeDRWaXZ6bXN6Lyt0K3F3Ump5?=
 =?utf-8?B?cEowOE5QdWlNdXJKb3BUeHIwYlZEaXhMbGJzSVpQZmpSUWlhWW9OanpVOVQ3?=
 =?utf-8?B?MFNiN21xdWRrQkxncThkaUNRNkpiZnpQMlZFdXg1anB1dWFCTlROMjU2MjZW?=
 =?utf-8?B?UndOR1BybHBNVGM1VW9YQVNtcWhRY0pYRnlDdDlBSG1VT251OXkyd0tKZjg4?=
 =?utf-8?B?bDJIMzR5bXB3L0FXRmtFcDBQK0ZXdktYSEJEek5JdzdWbEdtcmp2VHIxaHZu?=
 =?utf-8?Q?7nHhy1hm2SUG5h2ZXkCDWyLKPNRHzkwjVwhW+cV?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 781b26db-6d96-4726-5697-08d964335be0
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 23:36:40.3815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jyDGO4r1LERxqUVnHU3Mr3Nc1AQC7A4wGxx4F+uHPDYKozca7ChZGcJ5KKjrB86ORq1dI2h2sJ8rseIDiJLh4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5294
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/08/2021 20:06, Vladimir Oltean wrote:
> On Fri, Aug 20, 2021 at 07:09:18PM +0300, Ido Schimmel wrote:
>> On Fri, Aug 20, 2021 at 12:37:23PM +0300, Vladimir Oltean wrote:
>>> On Fri, Aug 20, 2021 at 12:16:10PM +0300, Ido Schimmel wrote:
>>>> On Thu, Aug 19, 2021 at 07:07:18PM +0300, Vladimir Oltean wrote:
>>>>> Problem statement:
>>>>>
>>>>> Any time a driver needs to create a private association between a bridge
>>>>> upper interface and use that association within its
>>>>> SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE handler, we have an issue with FDB
>>>>> entries deleted by the bridge when the port leaves. The issue is that
>>>>> all switchdev drivers schedule a work item to have sleepable context,
>>>>> and that work item can be actually scheduled after the port has left the
>>>>> bridge, which means the association might have already been broken by
>>>>> the time the scheduled FDB work item attempts to use it.
>>>>
>>>> This is handled in mlxsw by telling the device to flush the FDB entries
>>>> pointing to the {port, FID} when the VLAN is deleted (synchronously).
>>>
>>> Again, central solution vs mlxsw solution.
>>
>> Again, a solution is forced on everyone regardless if it benefits them
>> or not. List is bombarded with version after version until patches are
>> applied. *EXHAUSTING*.
> 
> So if I replace "bombarded" with a more neutral word, isn't that how
> it's done though? What would you do if you wanted to achieve something
> but the framework stood in your way? Would you work around it to avoid
> bombarding the list?
> 
>> With these patches, except DSA, everyone gets another queue_work() for
>> each FDB entry. In some cases, it completely misses the purpose of the
>> patchset.
> 
> I also fail to see the point. Patch 3 will have to make things worse
> before they get better. It is like that in DSA too, and made more
> reasonable only in the last patch from the series.
> 
> If I saw any middle-ground way, like keeping the notifiers on the atomic
> chain for unconverted drivers, I would have done it. But what do you do
> if more than one driver listens for one event, one driver wants it
> blocking, the other wants it atomic. Do you make the bridge emit it
> twice? That's even worse than having one useless queue_work() in some
> drivers.
> 
> So if you think I can avoid that please tell me how.
> 

Hi,
I don't like the double-queuing for each fdb for everyone either, it's forcing them
to rework it asap due to inefficiency even though that shouldn't be necessary. In the
long run I hope everyone would migrate to such scheme, but perhaps we can do it gradually.
For most drivers this is introducing more work (as in processing) rather than helping
them right now, give them the option to convert to it on their own accord or bite
the bullet and convert everyone so the change won't affect them, it holds rtnl, it is blocking
I don't see why not convert everyone to just execute their otherwise queued work.
I'm sure driver maintainers would appreciate such help and would test and review it. You're
halfway there already..

Cheers,
 Nik








