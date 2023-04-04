Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200806D5E15
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 12:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbjDDKwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 06:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbjDDKvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 06:51:55 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5323AAF;
        Tue,  4 Apr 2023 03:51:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U3zO+kFKEr1hsRZ69r9zjhXpSNfi/vljBQoj44G3LQZ3vVBg9dP7PXJStDA02xBUGVsNIo8uIR8eGps9LOf85lPSRT7RHMHX3KAoDK37p/cX96dN6q2vbbHBG32XTyPJjygglYKujkxxwNyMtE5rdJta+0hTL6aGurzTnYZTLbPHXBF9R/J/YGIp6a5+BkGBqUetGWx+sEnVgdKDXchov4f3ga9xuKFMod37ImeoZzcTsadeZuiSGrbAdNxevN33cakQB/ZZnRmUx+pSbovytzGpblj9Pz0kODEb/IMt9FJ76C2lFmeq1fv0CY/dpD7+gh5CxmKTyRz3lNCLz0jMqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TLhCQ4kGc6J7L7A23Wh1DzImClEgoFzQbHBHC/iOsbs=;
 b=Mbkzxzb6FHpYrdQEvhikHBkIpZ9mkhb/P+4GQuXP0FjX16joZGs5sZxChqxVje2+C+sfYL/F3xdZh8yD1v5B8CvWBz1hrqssYv6lKVFUJewXs90CUjnm3bpHvyfj6d8v894LvYYmJQHmXMxj7/lgEVZNdSUV9TNWn2EWZ37WIVkQlTpwQqWyrO2bFMW/HjYEpbrOBVRlBLHzy5STQqQeBo47xVQTu/UGItgogxJhq9Qw7+3XnaIivY2hVjYDmF/yKUnzi5mCaM0ORRfA+P1sHQxAVLf/qoJLCy3DWlojHmyPr9NadjOuwzc/rgtJPEZ8dJQx+xhxBGL7r3eyLmsXEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TLhCQ4kGc6J7L7A23Wh1DzImClEgoFzQbHBHC/iOsbs=;
 b=DwmV9fe05ijqgkGCkxZfCC7uuPMvV7gQfc2rltFTfQ0a0TocgzqTTYCT+OTBzmPt3sLrjnXymRwwHnZZsPEK4s9eU0BB+5veFiOz3nalJcp/UO7Qx97bgwOJFMtAeuZncSLX9NvRiRjXN4ys6ejoKSsYvWWssBy21JSmyF5XJN0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5628.namprd13.prod.outlook.com (2603:10b6:303:183::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Tue, 4 Apr
 2023 10:51:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Tue, 4 Apr 2023
 10:51:20 +0000
Date:   Tue, 4 Apr 2023 12:51:00 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jia-Ju Bai <baijiaju@buaa.edu.cn>
Cc:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mac80211: Add NULL checks for sta->sdata
Message-ID: <ZCwBFL/nZ+S2Df3N@corigine.com>
References: <ZCBfHlOhU8LjdRg3@corigine.com>
 <f70554b9-eedf-43e4-9a55-a809e9b9e89a@buaa.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f70554b9-eedf-43e4-9a55-a809e9b9e89a@buaa.edu.cn>
X-ClientProxiedBy: AM0PR10CA0132.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::49) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5628:EE_
X-MS-Office365-Filtering-Correlation-Id: 909772e2-3cf8-44a5-86d5-08db34fa8673
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JDLupCcCgU4zkL6xMw7MI0dNAUU6mWvaiFwQeVxLYIwiU2zbG7rbWxbRc7LFV87onGxAy9ybSl4fbAxMr3kuwiyOZNw6K6UTTazTlRypHv+2nsHqqppCZ1i9SBGuj1IsC06F4xaiga90P7kQhyQlxBY47IouZDatktD10K09kAAxpxeX5xSMJcbUsN9JSLH4mmD4H5LyeMG8SlRYl8tj1I/e6aZnpakQ2HW84hIwWji4MPnBl1aTSGh7fq5a7pQ1pnLF8yK4fh4EIbUFOQozunG4wpHljXww8FQ/LiT/zfePrHwz2HkyzLs+2qXYJE5Z+zLgBh+IrR6yn3y9wEW/kqmqONFktLMaE/0i5+S5qsBdSLEXAexZlsB/qATRr7nWFDAiMvz4Sa7n/IKCb5okbkyrFUSBM27iehUhTvB+//mOfcEMCDrrAykjCfwJRLiAMHtnrN70gL4A3WaHuGCzK17za+1820U6OFEOrFM9WhzjSM9w20BcVck5cWql62XuB/RIyPv11XmBDz/+J+9NF/wAhPVV1Tm5VrTUxqa9JjSfRUW6oeRYpXIabW4ZSGle
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(366004)(39840400004)(396003)(451199021)(4326008)(6916009)(66946007)(66476007)(316002)(8676002)(6486002)(36756003)(66556008)(6512007)(2616005)(53546011)(6666004)(38100700002)(186003)(83380400001)(6506007)(8936002)(478600001)(41300700001)(86362001)(5660300002)(2906002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnFtRFltanlYNE4zTldHQzFJa2ZZQmMzeURGN3NxZFF6dDV6b05weWhyMXBz?=
 =?utf-8?B?YXJMQXFKZXdOUWtXcDNYY1ZMTFJCMWRhcS84STlwQ2JqcFZvbmFicjdselN0?=
 =?utf-8?B?aXdQNXRpZ2srV2w1QTI0MmVsZWU4RkxIeWFwdEE3SW1idXNhUGpoY2doQTB1?=
 =?utf-8?B?eDBDVlNrU2NoWUMvREYvaHFLcEJWWmwvSnRldklOMnkxSzNNWDdGVHlueHp0?=
 =?utf-8?B?T2tpaXVwaHV3WW00aUtnd0pIeW9meEtVZ2hHaXlqSS9jTTJlWXlzZVFZNmdB?=
 =?utf-8?B?dFgxTU1tSFFwS0tjeVFEZEJSNzNSMnA3OXlLbFRQMEZNREo4NnZhdDJkdEJ3?=
 =?utf-8?B?TUsvbGpRWkdzVU01NE82VmtLQmFmUzQ3aC85MFhlSTdzOFVlUmpWN3BIZEtL?=
 =?utf-8?B?Z2MxajJTL3ozMzVJMGVxS0RhbGZnRXRlNDgwRmRBYlR4K2V0R3RtTlBLZFB1?=
 =?utf-8?B?ZzU5aHplNEY4WGIvSnNmdktSQjVGVy9IV1loRi9MekxWR3pMS2VBbFViWlh2?=
 =?utf-8?B?UDBwNC9CeFBpa3VVVE1XaW5jVEJ4clFUOG41UitmZSs2eXhKU1pYUW5hQUZ6?=
 =?utf-8?B?cUM3Z3dyY1djbDJlckZzNzhhMTFpRHFQVXM4WnNza0xNZFRUUzFkeWJSU0tq?=
 =?utf-8?B?RW9QSnJLbUxRQ2w0bFNaWVZVUFpaRFFxaElBRjdlYU8xU2oxaFpsdEdRdTFE?=
 =?utf-8?B?QkNqUnFtdm5Ib3pZb2QwcWpKMjI3TFd4SHlFdFlNa0w0NlRvbTlTQ0k5djk3?=
 =?utf-8?B?YzV3bXA3NE1oTTRIQXZGMHhsUzMwWld1WnA5alVHRVZyQmwwTnVpb1FYSkxq?=
 =?utf-8?B?a011WDJRdkNxdE9IUXdyZWNGZDRwb0QrNWVRQkQrcXltK3RacSt1Y21WcGRB?=
 =?utf-8?B?ZlhKTjJaYllrUTIxclc4aFg3Y0NDODArUVdNeVNxUTRnK1l2TG1FbnRIbC9j?=
 =?utf-8?B?YklIcHBEaXBYSy9tMTY3amtwNWtHa05EdWh0L2dFMEJGQVhmbjV6VVVGcWZL?=
 =?utf-8?B?L1NTK3NIZG9lNWJMOUpXZTA4UHZhNkw0aWN6U3NiVFFwQytwdjlSUXZLY0p6?=
 =?utf-8?B?MWJqL3B3SGFKajIwVk4rd2l0MVlnM3NlYSt5L0tGWnUrUkUxbk8yNndnaUtq?=
 =?utf-8?B?cXJCQ0dsSjc2eXhwQ1dRTHRkb1lkNHlrY3hMSmFxbGlqb1BDMHRBOTdvWWlu?=
 =?utf-8?B?dWpTb0tzdWx2aklxL2hoNWRWTkFoMUFiRFg4eU54dEhNQ0xkSWQydXJ0eW5R?=
 =?utf-8?B?a1RKUzVZWW9tWjlHbDFEQVgvaGpXdjBiaDJSc3FzRkZpSUlaV2dLbVptUStZ?=
 =?utf-8?B?RmZONGpXVFNDbTlpa2w3dDNMdWJKRitzSG9JUXkzdWIyc0huSDk0bUdLSjQ4?=
 =?utf-8?B?ajVBK1hwMHMxY0lickovUGMvaU4xMitTRDd0c2liM1lpNDlXdEpzcnJGYjRS?=
 =?utf-8?B?Q3BzNWJ0dDZxMmdDcHdYalJYL3ZPbWoyWDJNeElpdUxBRGdheVJYeTN6LzJv?=
 =?utf-8?B?dDVZVW96dVBWY1lQWFRublBiUldSckFEalp4M1dBcXFERElDeG9QeGFzUC9N?=
 =?utf-8?B?ZlM3L3l0ZFYxZm8xb01Td3Y5SktJckpXdlJ5c25UYWxXWDAyRG0zSmFMWTdT?=
 =?utf-8?B?djBGY0dkWXNHK0NXU0oxZWM4Vm56VW8xY1Z2MlFZMExKK0VDaFV3bWVaSG5o?=
 =?utf-8?B?ZUtDeEdTUUxITlV0V1RHUFFLSVFrQjNpZmlUajFiUmRXdXYvM05NcmZveC9B?=
 =?utf-8?B?UG5zcXloSmtuY3ZGK0xJL0FSdWxoalIwSFM5WmpkeU5peGZMY3NMamx2eCsv?=
 =?utf-8?B?RndSdjB0WTV0UWVEV292b3FQdU9RbVNGSEdkblhPaVFyZVNxdUU0anBHMExF?=
 =?utf-8?B?VmI4NDFoSm8xTEZJZnRVdmpySjk2U0RtK1FxZkxXNTF6Vml4bW5XZVNoUng3?=
 =?utf-8?B?K2VrMTIrMTRsSzJ6c2taWUZuT3JiYm5NVkNFYXIyRGhTK0toYnVtaGlCampI?=
 =?utf-8?B?bTA5SGdQR090SVlkdWV0eWJjbHRZVHZuL1VHVWM2NjFLbGIrVlVFenNyVTlP?=
 =?utf-8?B?RjJHdFltdzhPT01yVUFteGZRa0p6cFJXMnUydkN4ODNsSWxWbEVMTnpEZ0Rh?=
 =?utf-8?B?T082SUd2Q3dIL1J6RDRnVXpyU3podW8yYmJaR2NkQ21aUmNxNFNjTmJ4bWZO?=
 =?utf-8?B?ajhTYVlieWlBSDVFMjFYcUo0MVJIbXhBdng1bFdVRnpMZUt4NlpINVBISkFP?=
 =?utf-8?B?b2t3WkszVklRYXoxa1ZKT0dIL1dRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 909772e2-3cf8-44a5-86d5-08db34fa8673
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 10:51:20.7031
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QL3X88l+OMlq9A/zSWqiGuxjhLG9JKFSeyCbtgaIzYzGTT57TiknMz3zvn1nbQZ3wBMJvUKQnqHLuUh5l4mF6sAVACPo54YwYpHxg0/8JZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5628
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 05:58:13PM +0800, Jia-Ju Bai wrote:
> Hi Simon,
> 
> Thanks for your reply, and sorry for the delay.
> 
> On 2023/3/26 23:05, Simon Horman wrote:
> > On Tue, Mar 21, 2023 at 05:31:22PM +0800, Jia-Ju Bai wrote:
> > > In a previous commit 69403bad97aa ("wifi: mac80211: sdata can be NULL
> > > during AMPDU start"), sta->sdata can be NULL, and thus it should be
> > > checked before being used.
> > > 
> > > However, in the same call stack, sta->sdata is also used in the
> > > following functions:
> > > 
> > > ieee80211_ba_session_work()
> > >    ___ieee80211_stop_rx_ba_session(sta)
> > >      ht_dbg(sta->sdata, ...); -> No check
> > >      sdata_info(sta->sdata, ...); -> No check
> > >      ieee80211_send_delba(sta->sdata, ...) -> No check
> > >    ___ieee80211_start_rx_ba_session(sta)
> > >      ht_dbg(sta->sdata, ...); -> No check
> > >      ht_dbg_ratelimited(sta->sdata, ...); -> No check
> > >    ieee80211_tx_ba_session_handle_start(sta)
> > >      sdata = sta->sdata; if (!sdata) -> Add check by previous commit
> > >    ___ieee80211_stop_tx_ba_session(sdata)
> > >      ht_dbg(sta->sdata, ...); -> No check
> > >    ieee80211_start_tx_ba_cb(sdata)
> > >      sdata = sta->sdata; local = sdata->local -> No check
> > >    ieee80211_stop_tx_ba_cb(sdata)
> > >      ht_dbg(sta->sdata, ...); -> No check
> > > 
> > > Thus, to avoid possible null-pointer dereferences, the related checks
> > > should be added.
> > > 
> > > These bugs are reported by a static analysis tool implemented by myself,
> > > and they are found by extending a known bug fixed in the previous commit.
> > > Thus, they could be theoretical bugs.
> > > 
> > > Signed-off-by: Jia-Ju Bai <baijiaju@buaa.edu.cn>
> > > ---
> > > v2:
> > > * Fix an error reported by checkpatch.pl, and make the bug finding
> > >    process more clear in the description. Thanks for Simon's advice.
> > > ---
> > >   net/mac80211/agg-rx.c | 68 ++++++++++++++++++++++++++-----------------
> > >   net/mac80211/agg-tx.c | 16 ++++++++--
> > >   2 files changed, 55 insertions(+), 29 deletions(-)
> > > 
> > > diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
> > > index c6fa53230450..6616970785a2 100644
> > > --- a/net/mac80211/agg-rx.c
> > > +++ b/net/mac80211/agg-rx.c
> > > @@ -80,19 +80,21 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
> > >   	RCU_INIT_POINTER(sta->ampdu_mlme.tid_rx[tid], NULL);
> > >   	__clear_bit(tid, sta->ampdu_mlme.agg_session_valid);
> > > -	ht_dbg(sta->sdata,
> > > -	       "Rx BA session stop requested for %pM tid %u %s reason: %d\n", > -	       sta->sta.addr, tid,
> > > -	       initiator == WLAN_BACK_RECIPIENT ? "recipient" : "initiator",
> > > -	       (int)reason);
> > > +	if (sta->sdata) {
> > > +		ht_dbg(sta->sdata,
> > > +		       "Rx BA session stop requested for %pM tid %u %s reason: %d\n",
> > > +		       sta->sta.addr, tid,
> > > +		       initiator == WLAN_BACK_RECIPIENT ? "recipient" : "initiator",
> > > +		       (int)reason);
> > > +	}
> > The first line of the body of ___ieee80211_stop_rx_ba_session() is:
> > 
> > 	struct ieee80211_local *local = sta->sdata->local;
> > 
> > So a NULL pointer dereference will have occurred before
> > the checks this change adds to that function.
> 
> I checked the source code again (including the latest version 6.3-rc5).
> The first line of the body of ___ieee80211_stop_rx_ba_session() is:
> 
>     struct ieee80211_local *local = sta->local;
> 
> Thus, there is no dereference of sta->sdata.

My mistake, sorry about that.

> In a different function, namely ___ieee80211_start_rx_ba_session(), the
> first line is:
> 
>     struct ieee80211_local *local = sta->sdata->local;

Yes, I see that too.

...
