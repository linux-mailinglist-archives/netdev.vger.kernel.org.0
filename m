Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684B83E48ED
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 17:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235646AbhHIPez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 11:34:55 -0400
Received: from mail-bn8nam08on2074.outbound.protection.outlook.com ([40.107.100.74]:9697
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235537AbhHIPeC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 11:34:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CsZ5FGJBJ8xvUT+FwujVTAaW58nNhnEAPnEYVpLT1MH3eYkkEJ/+DYSc5UPuFn0NBmcnxR4cBBajX0vvd5hFHzXCxC+FmUXWKAjk+bM2YfhYmGuDnQMPymkKZFMbqQ4e6ctLTkVwUn5FG/7a3piXuPTnNZk4WaDT1+awRw1mVDQOmq76fZj/sCVe+OoFUy9DNIr+w+ygeKZUlbbBPaBzZwsVgfI4YMdGj7exMBrl26n06G4z+/I9ERKsS3WqlYl+b9jkvWFdRYy0crw7jMTG2Z7GtOEhl8z5U47eynnwQDQDjTyInKUTI77oWMVTSD3bdGlSyI5Rks7mqohXBMy4RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qqemeWm7qmixJcm6scXCyBgUPiNKCCgr7FJUNgLmrMU=;
 b=aaNhpLskaEFi3ykTeIRqMfuzttS+ognWefnFurN4hKpmEPTlbifhMOwZUncYsH/RVB2/BJf/N1Wq5vwLBZtZIoJfjcLj9wsojcx/KM3FsP7Ax9LNa3yODp+UrjKCpdOuzhho3iRqELUDn+Z85IiNV1ooA0oNxx8i6Oj3+wOxFBOuOgIAFBM1ga8grpZ9lnMYfgZuj2Essjy8Du97oN//P0gbndV8wluwq/UvWEfxpbmWRKoN7AKgIyqI1DOC2/YINsiNsxfUuufyQxkHW2HUgvwz7gXjNyomAcYgiGgW3Pt7Rh21sW85ebHpXFbXc0wh30WrezpXi1pRebFT3giwwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qqemeWm7qmixJcm6scXCyBgUPiNKCCgr7FJUNgLmrMU=;
 b=k+TIdDqC1YhTmo0f1Kiab6Ol/PU4SBXCHM2KmmF+8cPRZucwGp99QgpH+6lyiV7IgeLZ6MmdgMlaM+1KqI+ZQrmLI4ts87W08LOYvR+eQ4DMZTlN1H6oasR1MFfxJIH4lJJcf9EF95EmT6KKw1UXm1xaEwB2AAMNOOsWW3hVIcoueT29B5mmxNA3XLUXX3DzJz0tlI8cVTXNgzgcli2ycjwnNzjhHrORV2EwP7gjxbvTFWHUZbwJlLs6WLBQj1xCg0utBphwpc7iFvs1bpKnu5UiUZ8pVsK0wLxoSdlY24slDhVwILM23pSdQ2qeoCSw4conqruo/MKdNvcHaw2I1g==
Authentication-Results: syzkaller.appspotmail.com; dkim=none (message not
 signed) header.d=none;syzkaller.appspotmail.com; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM4PR12MB5248.namprd12.prod.outlook.com (2603:10b6:5:39c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Mon, 9 Aug
 2021 15:33:39 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::c170:83a0:720d:6287%6]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 15:33:39 +0000
Subject: Re: [PATCH net] net: bridge: validate the NUD_PERMANENT bit when
 adding an extern_learn FDB entry
To:     Ido Schimmel <idosch@idosch.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>,
        bridge@lists.linux-foundation.org,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        syzbot+9ba1174359adba5a5b7c@syzkaller.appspotmail.com
References: <20210801231730.7493-1-vladimir.oltean@nxp.com>
 <YREcqAdU+6IpT0+w@shredder>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <da3ddeb1-eef1-a755-dfa0-737e32065d67@nvidia.com>
Date:   Mon, 9 Aug 2021 18:33:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <YREcqAdU+6IpT0+w@shredder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0036.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1c::23) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.187] (213.179.129.39) by ZR0P278CA0036.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:1c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend Transport; Mon, 9 Aug 2021 15:33:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f77c1cde-e80b-4cb5-2c7e-08d95b4b0f71
X-MS-TrafficTypeDiagnostic: DM4PR12MB5248:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM4PR12MB52481859FD1F76DD8CDE94D6DFF69@DM4PR12MB5248.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oQlfA+aq+nPbEwLJtYc/J5+/yP/ITA2UmMT5Tp7GIXZJ2irmmxnLlh3krUdcnqy5Tr+YlgRghf0+eh8zDmM9z7y3A0kKbenelVk+mylX445bPjb4IeIRrqrsF6u6F+ln7AZxB25y5x3Aus0vYCseTdq65piDDJviYU2ILZAJxWBAvVkTRXE0KCwrOl4AtKOD3c/3/5MvANU50vXgroOXJHK7lhQrmCxIm8t7CeY5ymmzNAL5XWtBQpaTbfiPZMJsxbkTtLGAHHS3QUaaj9ByVE6Kdape9Gqm9gmRHrJDCZho8VGUR/CimBwWV4Qjww4KnDeCII4jjiThSIspUnvo0Qrtl0cgooQxYJSQs8ZZVd2dNRXWfV4x0GsRf6fk91+nRCHYg8lcTIRMWDEffibRmOinE0GAGNfV+y8qWGsZOgLgV0tO/oRLtJtCJn2xLNu9qMaWwTlsshnsy7KlHVROvc01rpTlDqhqWf9srfuh1jrlI9KfHWFDXR4Lko6RGcBMrKdTCLI+pIQQJHO6xPh4qAHcgku/yls+uFaqj6rkx+7M1/7TsqzyjJX/jFZHtAeei2uM+G/ZFdD94+X6pLhNcEVPQ79tgOEdE3hZuJ3+cAFkCTHO7So3zfw4TrfMNzGpeEJq+kdxoJ6kfenFnBDzkx0sElYYa8jozZpMHqydeZ/6iVom8jy/Hx1RdYF5NIZ413a/IvRzEzaEX3k08u4ozALk+zHJmSynw/Kh9peSd64=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(26005)(31686004)(2616005)(6486002)(8676002)(53546011)(316002)(66946007)(66476007)(186003)(15650500001)(4326008)(8936002)(66556008)(36756003)(110136005)(2906002)(478600001)(16576012)(956004)(86362001)(83380400001)(54906003)(5660300002)(31696002)(38100700002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N1JFWC92QWFZL2hLZUZnS0grMisvWXlwQVhlbW5qVWw1Y2pEQndkd2JBdXl1?=
 =?utf-8?B?ZzhvT2M1TEhZUTNuK1lNaHUvT2JSZHE3RzRRSzRhQ3dSSnpwNVdZZFJtWW1k?=
 =?utf-8?B?TXVPL1hMeWIzNit4R1BCWEk3Ty8rUkx1U3pHcno0SXZkUlEwWDRxU2U3T0xV?=
 =?utf-8?B?Z3RldS8wSHpPZWxrVlU2UzBCUnpUbkg3Y2Q4M3YxQW1KSUNFWUkyWG0zYndw?=
 =?utf-8?B?ZjVOQ0JRUTNOSExvZ1hDT05xeUV2eFJGd1RvZzZ2ZCtIcThESk9NKzJUckJi?=
 =?utf-8?B?c0tqbEVMV21haGVGVVNvSDAzbTA4WWN0SDE3SDZUaGJLZW1SbXpmWFNaMUtw?=
 =?utf-8?B?WW1JOWhzSWZOZXpDOUFESmFENFcrUW4yTTZxMDkvanN4dXk2K3dzMDJ3VG90?=
 =?utf-8?B?Ni9uNDJPWmdNY0pYakMrUlFURlFCTiszSUtmQWNRQ3ZJUGwxZkJYNitxb0Vt?=
 =?utf-8?B?amV0UVNPMUQ5NTU4dC9kczdhcWdHNkhnaXRZVExQU2xpencwaHhuWjJySkdB?=
 =?utf-8?B?RU4rY2owVmRyK1MrTW9NMzk2ZXd0UjVpa1ZNcGZiOVloSFJZUVlMZ1IvZzdt?=
 =?utf-8?B?Q0Y1SFZ6Zm1QdG9LRHFiRnV0cHhOSHVxZGdFS0h2QkVPM3JwcllQOVJBZ1hN?=
 =?utf-8?B?ano4ZUtXa0JxK00zdFRvc1FwUUxrWVdIeFpJc0VsQ01GeGlpNDB0ek03Q2Q4?=
 =?utf-8?B?UXByYXRWQThadlpGWHZLS3hiM0tWOFFwN2c5Z0VsVVFRVjFIN2p6blFtM0d5?=
 =?utf-8?B?dndkSnNiR3p4Y1lOVHIrOHNJM2l6N1hhMU54YnV4MlFpa1RzMTRpdVhoQ1dO?=
 =?utf-8?B?TU9KRHVaemxZdTJvTXI2b1d6QjI3VjF6OFI4cXBmcjQ4Skp3NlNTMzd3SHpY?=
 =?utf-8?B?Z3k0NU1LeWtyNnlKQU5yekUreHhZbkNySVJLNFJPNE0xbTV6YlpzbnhweC9r?=
 =?utf-8?B?UTNZM0svRHRvYmVKMnhMeWNvaExkVUlUeEIyaGY2djJIVHpodEhpaXVQOHhD?=
 =?utf-8?B?MWRJZDNVUWYrc2QzWE11SWFSYVVDKzdETTNqVTkzeGo4Y3ZROXJoT3BybEp6?=
 =?utf-8?B?Wmg0d290dXpzdDFBYm9BSE53RE9qRnJMWjhWSnNGTkNiVHZEOVlMcVBUMktO?=
 =?utf-8?B?aHM1NEJRM2lKYURFVlpxanVoQnNhOUpWcUEyc2ZFejFpZzFvSXRnYnNWTDNz?=
 =?utf-8?B?anRLNmZja053NUYrWlVIWkZkYy9VaGNyZVYxYUxUNDAyVmJydTNrclN5Qkln?=
 =?utf-8?B?ZWNzZEpDRitBbjZqTHArcVM5OVNPWjZGeCtRS0o3eVBuMFA3WUM1WXFBdU1K?=
 =?utf-8?B?UjF5SERPY1N6REplSW81UmttaXdmU2c3K1RyTnpSVjVDSnhLVEpKMFoycW9u?=
 =?utf-8?B?WEx4Vzdld3VLWjQ2NGxxbHVJS29zclNlV04zVE10YWkxOEFQV20xd2NwTnRo?=
 =?utf-8?B?QjNxZDVYUG1pSWVsWWF0NDhIdnd1UDNTYmpua1l2czM2dWlLZ09UcDk5Nkty?=
 =?utf-8?B?bG00QzFTQnVQSUpoamkwdzMvWWpyQkordjBVTnFZa29JRkxEM0dJQW05QlV1?=
 =?utf-8?B?OUhHOXZRL2UvcjZ0MHI3dTlJT3ppRXIxa3dxTlo2K0V3SUV2OEliK3dpdGxu?=
 =?utf-8?B?QXFEL1N2QWdiUzhQMWNlUStMK0NpQ2lsdUoyMTJtaUlaOU9vc3EvcndBSVo2?=
 =?utf-8?B?WUFjSXB0WFpnS3I5L0ROWGEvdFd5VEVOOGZBWitRVUtoUTc1TEd4eGk5UVlH?=
 =?utf-8?Q?UpSHet9wnKhVdbkoqz37OncPo2WLXalWWWn9469?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f77c1cde-e80b-4cb5-2c7e-08d95b4b0f71
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 15:33:39.0331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 50fnawLZrdM0zjZFH8mdVeK8hXyG8nO0s56olnCbAAgts/bYSVT+VvAmTKaI+wAi9sepD3jgsXax8edHnZp+Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5248
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/08/2021 15:16, Ido Schimmel wrote:
> On Mon, Aug 02, 2021 at 02:17:30AM +0300, Vladimir Oltean wrote:
>> diff --git a/net/bridge/br.c b/net/bridge/br.c
>> index ef743f94254d..bbab9984f24e 100644
>> --- a/net/bridge/br.c
>> +++ b/net/bridge/br.c
>> @@ -166,7 +166,8 @@ static int br_switchdev_event(struct notifier_block *unused,
>>  	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
>>  		fdb_info = ptr;
>>  		err = br_fdb_external_learn_add(br, p, fdb_info->addr,
>> -						fdb_info->vid, false);
>> +						fdb_info->vid,
>> +						fdb_info->is_local, false);
> 
> When 'is_local' was added in commit 2c4eca3ef716 ("net: bridge:
> switchdev: include local flag in FDB notifications") it was not
> initialized in all the call sites that emit
> 'SWITCHDEV_FDB_ADD_TO_BRIDGE' notification, so it can contain garbage.
> 

nice catch

>>  		if (err) {
>>  			err = notifier_from_errno(err);
>>  			break;
> 
> [...]
> 
>> @@ -1281,6 +1292,10 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
>>  
>>  		if (swdev_notify)
>>  			flags |= BIT(BR_FDB_ADDED_BY_USER);
>> +
>> +		if (is_local)
>> +			flags |= BIT(BR_FDB_LOCAL);
> 
> I have at least once selftest where I forgot the 'static' keyword:
> 
> bridge fdb add de:ad:be:ef:13:37 dev $swp1 master extern_learn vlan 1
> 
> This patch breaks the test when run against both the kernel and hardware
> data paths. I don't mind patching these tests, but we might get more
> reports in the future.
> 
> Nik, what do you think?
> 

Ahh, that's unfortunate. The patch's assumption is correct that we must not have fdb->dst == NULL
and the dst to be non-local (i.e. without BR_FDB_LOCAL). Since all solutions break user-space in
a different way and since this patch also already broke it by the check for !p && !NUD_PERMANENT
in __br_fdb_add() which was allowed before that, I think the best course of action is to ignore
NUD_PERMANENT in __br_fdb_add() for extern_learn case and always set BR_FDB_LOCAL in br_fdb_external_learn_add()
when !p. That would allow all prior calls to work and would remove the dst==NULL without BR_FDB_LOCAL
issue. Honestly, I doubt anyone is using extern_learn with bridge device entries, but we cannot assume
anything since this is already a part of the uAPI and we must allow it. Basically we silently
fix the BR_FDB_LOCAL problem so old user syntax and code can continue working.
It is a hack, but I don't see another solution which doesn't break user-space in some way.
Handling NUD_PERMANENT only with !p is equivalent, unfortunately we shouldn't keep the error
since that can break someone who was adding such entries without NUD_PERMANENT flag, but
we can force it in kernel, that should make such scripts succeed. Traffic used to be blackholed
for such entries and now it will be received locally, that will be the only difference.

TBH, I want to keep that error so middle ground would be to handle NUD_PERMANENT only
when used with !p and keep it. :) WDYT ?

Solution which forces BR_FDB_LOCAL for !p calls (completely untested):
diff --git a/net/bridge/br.c b/net/bridge/br.c
index c8ae823aa8e7..d3a32c6813e0 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -166,8 +166,7 @@ static int br_switchdev_event(struct notifier_block *unused,
        case SWITCHDEV_FDB_ADD_TO_BRIDGE:
                fdb_info = ptr;
                err = br_fdb_external_learn_add(br, p, fdb_info->addr,
-                                               fdb_info->vid,
-                                               fdb_info->is_local, false);
+                                               fdb_info->vid, false);
                if (err) {
                        err = notifier_from_errno(err);
                        break;
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index b8e22057f680..4e3b1b66f132 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1255,15 +1255,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
                rcu_read_unlock();
                local_bh_enable();
        } else if (ndm->ndm_flags & NTF_EXT_LEARNED) {
-               if (!p && !(ndm->ndm_state & NUD_PERMANENT)) {
-                       NL_SET_ERR_MSG_MOD(extack,
-                                          "FDB entry towards bridge must be permanent");
-                       return -EINVAL;
-               }
-
-               err = br_fdb_external_learn_add(br, p, addr, vid,
-                                               ndm->ndm_state & NUD_PERMANENT,
-                                               true);
+               err = br_fdb_external_learn_add(br, p, addr, vid, true);
        } else {
                spin_lock_bh(&br->hash_lock);
                err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
@@ -1491,7 +1483,7 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
 }
 
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
-                             const unsigned char *addr, u16 vid, bool is_local,
+                             const unsigned char *addr, u16 vid,
                              bool swdev_notify)
 {
        struct net_bridge_fdb_entry *fdb;
@@ -1509,7 +1501,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
                if (swdev_notify)
                        flags |= BIT(BR_FDB_ADDED_BY_USER);
 
-               if (is_local)
+               if (!p)
                        flags |= BIT(BR_FDB_LOCAL);
 
                fdb = fdb_create(br, p, addr, vid, flags);
@@ -1538,7 +1530,7 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
                if (swdev_notify)
                        set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 
-               if (is_local)
+               if (!p)
                        set_bit(BR_FDB_LOCAL, &fdb->flags);
 
                if (modified)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 86969d1bd036..907e5742b392 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -778,7 +778,7 @@ int br_fdb_get(struct sk_buff *skb, struct nlattr *tb[], struct net_device *dev,
 int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p);
 void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p);
 int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
-                             const unsigned char *addr, u16 vid, bool is_local,
+                             const unsigned char *addr, u16 vid,
                              bool swdev_notify);
 int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
                              const unsigned char *addr, u16 vid,


