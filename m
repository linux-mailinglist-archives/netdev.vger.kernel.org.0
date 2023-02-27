Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682186A447D
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 15:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjB0Oei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 09:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjB0Oeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 09:34:36 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC35166E3;
        Mon, 27 Feb 2023 06:34:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677508475; x=1709044475;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=saAbGgxf32MucDjorVLoPq6BnCGqucymhLGQIPrbvlw=;
  b=A0rnl9CsEj6wKlZeJjwF06scXPqZEpXakpTjxMZc3u2/bzDmKjFnQsEb
   80sQuxjOwaDk5eKVjysK1bZ60+tsmMGOaIaROfl0Z0nB9vjkhlgZwnn01
   Td0108meTKfdrnTF7qYq8KfnfxQOXPE4U4Z63VJsShWlIiph2lt+saAcZ
   CUMXBfHHdr9exQOYpUhfUwJYDCyaAiH29IRRDAMZpRPscJqAT5q0V6Upj
   w0gaaNip+xf8AL+5naxeGZLApNWBuEJk+Am1IjiUVnu0EbsGh0Yd8n3Gx
   0550ZMotRehsCGL+bOf0cPfL09/+2A9lhyVkvbkUOC8N4riquQ/AEobrU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="335350581"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="335350581"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 06:34:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="919375555"
X-IronPort-AV: E=Sophos;i="5.98,219,1673942400"; 
   d="scan'208";a="919375555"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 27 Feb 2023 06:32:36 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 27 Feb 2023 06:32:34 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 27 Feb 2023 06:32:34 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 27 Feb 2023 06:32:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5xr/Trzoc6kEg5ilC9T4xbqAlrNQhRIS5Arg3RR01Pa1qJOchRnt4rnIdNMR709FQ37q9aS75fRFQYvP9c2YkqFom0VCfbTQJPqH6DbRtSKCBTh2wO5kkNhXbit5xvifLEYMvUaCclhJelc0vJq+/ikwglwZofyFivGFOazR4+oDgkDEtMBnoxFqudKavaTMxm1iMXnU5cV6L5u5dIX92F2JMZBJCtnRymh1+BVPmQQkcYNHmLdZFyp2XbshTH2FKhwsgl2G5ljiBgd+sCCb1wRsjXEPkV+nUM8SwcS+2oeL7ezIkMAevRPnuK48UDThX+U/n4mviYXycGaBtc4PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejDA+e6Eqt6khfmt0XBbRzGV/8MOWHcUR7+dhVjpxJk=;
 b=eM5QzSb/OmsayHTmWsEH/uifv81n3jd5dCLPWrZmG5fd9SQMW2+TWNUnDc02epglUc7HfLOy7f185HvRafwQI5MLpXVN2evwTLIzSaILICbgmsS0AQsS2PAhF1VConFdGtyUz4UP33OL1AJzfyRwoq3g5UDDhk/OL9nSF6rUZ1R//q+wq+wI4K0qdc+WIf9zGKpoKKjheowvlEAQwTWhtboWiYdVIujDItLxB/0KF1eIsQIhg04pFVq1AM7dMPvDFH6CBjbVFgzdTGaLFiB81VhlKItOnri0FC8AgjRns72vCkfWmH9vBOto4ZeszTFMc4qYSMn7uyP8nPfmUaRZiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by CH0PR11MB8216.namprd11.prod.outlook.com (2603:10b6:610:192::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 14:32:32 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 14:32:32 +0000
Message-ID: <ca1f4970-206d-64f2-d210-e4e54b59d301@intel.com>
Date:   Mon, 27 Feb 2023 15:31:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 net-next 3/5] net: dsa: microchip: add eth mac grouping
 for ethtool statistics
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Rakesh Sankaranarayanan <rakesh.sankaranarayanan@microchip.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <woojung.huh@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
 <20230217110211.433505-4-rakesh.sankaranarayanan@microchip.com>
 <84835bee-a074-eb46-f1e4-03e53cd7f9ec@intel.com>
 <20230217164227.mw2cyp22bsnvuh6t@skbuf>
 <47a67799-27d9-094e-11c3-a18efcf281e2@intel.com>
 <20230224215349.umzw46xvzccjdndd@skbuf>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230224215349.umzw46xvzccjdndd@skbuf>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0143.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:96::17) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|CH0PR11MB8216:EE_
X-MS-Office365-Filtering-Correlation-Id: 7782880f-fdef-4c02-3046-08db18cf75f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: haFk9z1DkFYeG5DzP6Z782YdJxeClmBSdjbBFBVe74WVQhx8erlkYDNv1C8kYnbV+CJUM2yt78XVF3xzWKLKws9hfLGBmathaDFsVWyMWuuSgemnccXa8199rrmJuX5+4VgESKsHs9z0xdHNeiI1ZIiuR838yvH+eug2W6R53HuneBR2RVtIW3FkHC+PFhhtfsxMYODoM8jQrct+p0QktE4hDbkbNpBYR5QOfx7ZcDput2ZBOB4wwSUYb3hcQ+rgGZnsHPNu49ZDlkiIKNgeD3Uqvaz+C4DpJBTQprXoa7Dw8eLFH7jgveRZCzcBu9oBCV18gFMQVvIK9GZLz71m8PDP+Z+ijjGo/+6zGo/QvkuKSexA62NGAG4OXy18aX4oGZaMGAJXzwVroffpk61miqqbBuCR0UnFqkLH+c7WnSOHuraGGkpLdJe/PyImiLnYr3pBRyZ/SHAjSHy09fyZ5UQhr7mFp9YVCtCQw0gY/wj31B8mlI0gs6bOO2vf/mwBUqqLpXOqBmsXMwvsZMzFQ7GeDywMI3maz4bMrNJ7uEIN/WIfKLZe+a+4VA6lscQjtNbKqFTIcE9o6FyFjUmP1i9k2cXhEwCGEBvpfRgNne9IKbK35LPIwZRkjFXTBH/MCF8lZktVdHoMk+Elczm64WxY0IMVM2oMSd2dIi+H6EdDSLbieQcnhiqmMcDTtO1YeqPtjQqxkjIF7uKiPM0QIYL1snpV/xgGVk+dFdcFKQc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199018)(36756003)(316002)(83380400001)(6486002)(66476007)(2616005)(478600001)(6506007)(6512007)(186003)(26005)(8936002)(41300700001)(86362001)(31696002)(7416002)(5660300002)(66946007)(4744005)(2906002)(66556008)(8676002)(38100700002)(4326008)(6916009)(82960400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OEhKblRlcFdwa1pQdVlCNWRjL0FMaGtzYVROWTZCZ21JbTRRcUdYT0hqVUJU?=
 =?utf-8?B?K3czV01DUzVzYlhYOHlDcUV2cWppdXJWT3FmSE1YY0tXMW5sUjZlNjBhTnVS?=
 =?utf-8?B?OEppcDY2N3A3bGFxaTV1eTArQ0xZcGtldU1TUnBLcU9lWXZVTmtWRWNuVCs4?=
 =?utf-8?B?L1R0UHFZZ29HRU9RYWtheDE2b3haaGVDR0I2eTBVZ1FwR3N6ZFBBakJGaUQ5?=
 =?utf-8?B?OXhUbllGbWkrRTNhdkdsN0pLbXUzK1YvTS9GM0x5OGcxK05vRjZnMXFwcUMv?=
 =?utf-8?B?STNoUzdDNi9TWEdJbnlCcFp1TEJiZnR0Rm9qYXVBYUJUS1I5VHJzUDE4dldT?=
 =?utf-8?B?UUcrODI5bkFUbGpWZ0ZKUGY1V0ptLzNGVVRjVjZQUlFiUnJTQk5UL0prSnAv?=
 =?utf-8?B?a1l5QVZ6cHB6bDRZUWY1NEFwVVJYQXRBU0ljNTNCb3FxRkM3VjVNRzBTVTVZ?=
 =?utf-8?B?dTNRa0p2RWJLTjVmMEdWY0xyV0c4MDZiVFJZMFdjVlNBaHVpc3FxdGh0Ui9B?=
 =?utf-8?B?OGpiSjBjMWpGUXdEeUwvTk1EZVJkRzYwTXRYbG5XQVkyR21OUm9sZEZ3aVRS?=
 =?utf-8?B?a0IxWkVYOVBNRDErYUJNZUVLYmNiRWt3b2NRWFBER2V6Qmh0bHhwemdiNkRt?=
 =?utf-8?B?OTAwbWF4RkdKRzNKMDM3TURhOGpFbkMwMExZZUwxM01mamRsT25kS3pNRyt3?=
 =?utf-8?B?UXYyYndRTzVLL1BDbkdqcUxXNCtDUWRQWlVuTGVKbjFXRTRNSDlvYlVONzN0?=
 =?utf-8?B?bWZRTHBhUW5MN3R3K0dRbGs5VDN2RDlJUGlXdmNNYUxOSEpUN012dEI1Szkw?=
 =?utf-8?B?MUpnemdRdGxURHZ3RkRGZXhOdXA3YTJDWGFKSG9sRWJiUUVsODJPQ28rcDd4?=
 =?utf-8?B?Lyt1WVlqQlNJZzFRSCtEY282SGEvMmRCSkgzekJjWUVacEd3Y1U1a1NrbzRk?=
 =?utf-8?B?Z0FiaW8xdGsvNENUL3EvNTZrQnNnNzdCVkpONW1XTmxzRWw5MkVNNVRsaTFC?=
 =?utf-8?B?WVNiMG1ObGh0c2tGajhFayswSGc4TTJzRjRCQnpVc2t5WGlya3JNUDJKV0Vr?=
 =?utf-8?B?SjNEcmpmNDRVd3VRdGx6UXU3RVovS0pGM2ZVSXlUN1VoR3pnVDZ3TWZFQTVY?=
 =?utf-8?B?b1IwS0V0MGNzMnFIZ1EvRVNEbjkweXUyb1BkOFYvaEF5WVNmZnhaNm9iNzUy?=
 =?utf-8?B?Q3MrbWpKSXBkcVVNNzNPdlF0c3cwOVpiT1lhclJ5R0IyZFgxUUVwOEk5VWZq?=
 =?utf-8?B?VlovRXk5Z0JmR1AwMHN2Y1hJSFpaK3ZjMk96U250cFNRZitvVWN5djNPNWJW?=
 =?utf-8?B?UVFmZGpNbHhxaVlxR2h0Tk5OYzVaYXFSRTJWWkYrajBtNlArR1poOUliL1pp?=
 =?utf-8?B?V2tNcDRuaXptTWMyWGNRUytFOXZXdkx6SnkwZnNLZEQ5a3RaVldRN0xIR3d1?=
 =?utf-8?B?bmxENE1hWUp6d2s3ajNTZHV1TGRKNWR4OGt0T2xtc1hOeHE2TjgxeTlQOFcx?=
 =?utf-8?B?WkpTSU5yb2lTb0taL1dISkllRWE0Rk5IRVZWUVljOVZOOEJLNTJONUN6cEJk?=
 =?utf-8?B?OU5NNXVsZDBubkNob1hiaURBaENETkt1Umk2UExBQkxRQk9nYXRJbUphRjc2?=
 =?utf-8?B?UjEyMlVPd2VENEx6VFBmSHVQQmFDTDJmQWFHbEtZMkozdmpNbDZqK0hGc1ZR?=
 =?utf-8?B?N2F2STVQQzVzdkFqdzRzN1FNMndiM2lobU1iOUZabFFGQ0krczNoTk1kZzNY?=
 =?utf-8?B?WmhWZWlwZlBDaFI4L01jSGtidDQ0QzdxQlEwOHo0SFRsZkwvL01zbXlBbjJU?=
 =?utf-8?B?bWg2VktOVWNMd3FQU2E4V0tQOXRBaUJicXhlTlJQZFIzWG1mMFBzNVl2SlYr?=
 =?utf-8?B?cGlxaDFXZWtWWEVOQ1B5UDJaZ0lPRlhUeGpwQ3pJdWs5MXZVTVFDY0dsbDFR?=
 =?utf-8?B?ZTR5eEVSVkdnckRzU1VIZFNDT2hucmt0NWgvQXJ6eVBVVk5veHY2eGdqOWNB?=
 =?utf-8?B?bXQ3bEo1cmx2SUU1T01DZVhuQUtQNGU1bVJyR1VTeUJUYURScmNlcndCUXpo?=
 =?utf-8?B?MWk4Tnl5aDA0Wm9aMFVpU3RoUi91K3BCQ1dhRFk0ZFIwUytxd1lwbG13N3JM?=
 =?utf-8?B?U2N1TzdTS1czY3pFTm1GbTVDVjBMWHZIMDVWd2tDeDJpaFUxdlY2TUI2akJS?=
 =?utf-8?Q?0Qn5gPEtXD5VZI8qevxnGJc=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7782880f-fdef-4c02-3046-08db18cf75f9
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 14:32:32.2431
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A3VnxM86bUip0BPa3VWCTxbgVxZqIIF5WiAhKpnfVAd7jl4iZ6n4gnJEfxh+9U5yaHxALc4Gp62742aVltzA9ZQ2hR93XqfSKZKlbUB9ZXQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8216
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 24 Feb 2023 23:53:49 +0200

> On Fri, Feb 24, 2023 at 05:07:01PM +0100, Alexander Lobakin wrote:
>> It's not so common for people to show up back in the thread after you
>> ask them to show godbolt / asm code comparison.
> 
> idk what godbolt is, but if it's some sort of online compiler, then I
> suppose it's of limited usefulness for the Linux kernel.

Yeah it's an online compiler, which can spit out assembly code. For
testing non-complex stuff or macros it's often enough.

> 
> Easiest way to see a disassembly (also has C code interleaved) would be
> this:
> 
> make drivers/net/dsa/microchip/ksz_ethtool.lst

Oh, nice! I didn't know Kbuild has capability of listing the assembly
code built-in. I was adding it manually to Makefiles when needed >_<
Thanks! :D

> 
> This is also useful to see precisely which instruction went boom in case
> there's a NULL pointer dereference or something like that.

Thanks,
Olek
