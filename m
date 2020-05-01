Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA561C16AD
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731788AbgEANvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 09:51:45 -0400
Received: from mail-eopbgr1400110.outbound.protection.outlook.com ([40.107.140.110]:47163
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730772AbgEANvj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 09:51:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RXHxElEAL8CCR/RGVElZlwB9abzGyBXpjPUyycYHPuB249aQXz44YyoFbi7vroT5xsOqmnsSWKMOomahOT19WcTYivi/tCtOfY1KkCHKLm7bKiAzmjA0RS5sN7Ux4FLrsGzSGGgU9QDqlbdjeWcMWChAz0izJR00kSacIUbafMnPKpggWQAjXXuPCnlRmEEFkMDlzXTAJebhPSi4TKMqonWaQGvOe4iE/1pCHjcF7hGC1b4UupOOBcYIyM49ujw/Wrbxt7fuRhecUkrs0phoi4jk9F1FiFlm4Qu0h/fhtZwU+GXFcEo6nJEvTXVAMwv5Vb5nwCxC8mlTG9nVCOUBVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGlTDZ5iRDXPIoj59Wpc9IyvOGr846wv1pxBHG3xlnE=;
 b=e1EhlcJrQ/Vek0k3u4v5WMmzvhHh5jW1pkenIzHYqXh28CX706sbksAXVDwwXTiAWiCI0CUSbTS4p+fPSy/At5RjBIewVEYcVIF+qrLxCBColXEMkc2Cn6mMfF/eTwGtspwX3qK/JwBwsUUHOY2wP9pAHQ0YPnkxq1h0dMhWCzF27oBKddD1CsLAcT7mz8Jt4wIc7eJanHsNwRfOWxTqw8i53ZsQg50YyG7GnhdfogRUEnszElgrS6/hNXutwEFgBplyyfUstOoSs8AAzJmFYa47OghnN2o2cHD1NyYcbRtxCtxzhB3gohMs3xS9pq4zDst+I6R4iks6pSUFbdbvlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cGlTDZ5iRDXPIoj59Wpc9IyvOGr846wv1pxBHG3xlnE=;
 b=itLQrLn6rgBL44WAdYMrUszmKiMiSlDGYcHvtY/KDMPPxrrg0dKIGXMYxcteLEUeK2YjVQN+CM1R9YSWHFjmKHYKFfLgQTXm6t84SXMFGy2Jum/YCzBRJG8MrlsSIXvo2dzWAWhcEnBXluQuFQZMziLwWA6V7eEYFzFBjoU6ssA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
Received: from TYAPR01MB4735.jpnprd01.prod.outlook.com (20.179.186.82) by
 TYAPR01MB5264.jpnprd01.prod.outlook.com (20.179.187.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Fri, 1 May 2020 13:51:37 +0000
Received: from TYAPR01MB4735.jpnprd01.prod.outlook.com
 ([fe80::5079:4b36:6c93:3a5b]) by TYAPR01MB4735.jpnprd01.prod.outlook.com
 ([fe80::5079:4b36:6c93:3a5b%7]) with mapi id 15.20.2958.019; Fri, 1 May 2020
 13:51:37 +0000
Date:   Fri, 1 May 2020 09:51:29 -0400
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] ptp: ptp_clockmatrix: Add adjphase() to
 support PHC write phase mode.
Message-ID: <20200501135127.GB19989@renesas.com>
References: <1588206505-21773-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1588206505-21773-4-git-send-email-vincent.cheng.xh@renesas.com>
 <20200501035601.GC31749@localhost>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200501035601.GC31749@localhost>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: BYAPR07CA0106.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::47) To TYAPR01MB4735.jpnprd01.prod.outlook.com
 (2603:1096:404:12b::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from renesas.com (173.195.53.163) by BYAPR07CA0106.namprd07.prod.outlook.com (2603:10b6:a03:12b::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Fri, 1 May 2020 13:51:35 +0000
X-Originating-IP: [173.195.53.163]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5d9b2d26-7518-4d73-b4d5-08d7edd6c46c
X-MS-TrafficTypeDiagnostic: TYAPR01MB5264:
X-Microsoft-Antispam-PRVS: <TYAPR01MB5264F6BE934B89BD39D95F2BD2AB0@TYAPR01MB5264.jpnprd01.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EswukDLn+iqhTbPg6WJPiH3I5EJO/BKiKruWSEp/9dJeQc9MxcYBIcIFhgcmhE1YD9aa2BrpluIdgQxi9F6PbBA09l92aYnjjPfEMjEySFHi1lkBaEh3Rwycto2/1eC99JecUiTM9cIZ4rZYgWbQSwPM3YnAgyYcmU67YIW2JRboHdKm/Gq0Q4db69oDKtg0Or9xXFzFOn/j/2njQhkCg2Crw+AZVj57o7/3LsftSFF9At9Lsu+yJhGsw01vFoHT5Ignvq4ngwFH2Qo9DUO+nSnfssAdkmzdezjIE9+mC3CsxG4IzQLlA65Pj3OUgUQ7ZVp3t+2/4GRpMOAmyiHFnCBswmdsSDtWQkkL2zRHh3WPTmLz6rIhb2tKfWHXKY8jIftm4IkpcUH2rICVDMG64BSh5r0GaDAcYlemE3HfyMp9JWNO/EVLUb0ITx2Hc5d8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYAPR01MB4735.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(5660300002)(66476007)(1076003)(6666004)(66946007)(66556008)(4744005)(86362001)(36756003)(52116002)(6916009)(7696005)(186003)(956004)(16526019)(2906002)(26005)(478600001)(8936002)(33656002)(316002)(8676002)(2616005)(4326008)(55016002)(8886007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: YJdXW+kOzdjJMX6KhTuPCvg4Ktof0iMxjGBdpU4Brs3wzTpbFixtEDkQasuijH8GOgdTyV5OsB/F1WoyR4hIPiLeuO+yHtTSpoDs9jaF56AvZms1Bk4MxCTWyNEVkueG5DldXUbxl3Hf7vGcnLN2Pz1yS4WJyd7P8cvtmjQsq9uyqD2Ml2E+oRSSrY7huMbqJb0FU58ibdXN5K/CD2MPIMyIs/YGoHNfd0FyYYEqXhp0KdKhy+O2VZHzat+ZkrM6+yWPcimyncVbYanhEtnzTLMqo+aJh2EgaD+8N0FxgOcDTeBxX3Fecu4AzAkJ++C0P+eiAdu00brnMUhgy2PAPWX1jMGo6EH0QvHcD3QXvedQPulZ5Ix3+UsRaUd/fsyQu/wvh0F6S0s+ETOw1XahCv5/Z/iC9hnosyyx94dL59J0kHwAzYptV4DGxppIqnRrfebJA51UAqzTAOEzlJTUtKOkmtcqYq4NzQIIy6Aqp1bcw4Qj/MjWNvPX1V/wyTa/KPdVMFnLuf03NT3CcfG9LxFvrl/vmntRKlLjm2CXtz/km2ZfFH9B6JHbGXfKM3gSBsnWtVHurQ/kHehFkGFfLrM4ENAzVDB/7YJ1mr8DmJQhYU/d1eQ46kIAfwCIVA+OFmvw5ccl4E5fedBAXxaaoucbPjUsG+XiJEC/x0Y9/pY6GTtG2j38my6vTa7H/3F74FQ+3N89aqQDEd5fJb+OGIKI3Z3u1kvDSpquuwL/20k1eShhtioawyFloqEzlCPAcfsalKwuttr4ZH6m7cM9nGR/0LGNZgkx1pgp3VwqmUg=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d9b2d26-7518-4d73-b4d5-08d7edd6c46c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 13:51:37.3045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VyZIKSubb071N9icFwZ0xSDJaFf+F+ZFseqIPc4IDuUxfbAAQdpx4m6YCTa34IFfgMfLYKmXstl4oVq9GxaxeYEkv2Yhxp+UmKWoj1T4tAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5264
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 11:56:01PM EDT, Richard Cochran wrote:
>On Wed, Apr 29, 2020 at 08:28:25PM -0400, vincent.cheng.xh@renesas.com wrote:
>> @@ -871,6 +880,69 @@ static int idtcm_set_pll_mode(struct idtcm_channel *channel,
>>  
>> +	int err;
>> +	u8 i;
>> +	u8 buf[4] = {0};
>> +	s32 phaseIn50Picoseconds;
>> +	s64 phaseOffsetInPs;
>
>Kernel coding style uses lower_case_underscores rather than lowerCamelCase.

Sorry, missed that.  Will fix.

>> +		kthread_queue_delayed_work(channel->kworker,
>> +					   &channel->write_phase_ready_work,
>> +					   msecs_to_jiffies(WR_PHASE_SETUP_MS));
>
>Each PHC driver automatically has a kworker provided by the class
>layer.  In order to use it, set ptp_clock_info.do_aux_work to your
>callback function and then call ptp_schedule_worker() when needed.
>
>See drivers/net/ethernet/ti/cpts.c for example.

That is nice of the API, thank-you for the example.  Will fix and re-submit.

Thanks,
Vincent
