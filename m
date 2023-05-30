Return-Path: <netdev+bounces-6485-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5404C7168C2
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:09:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09474281191
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11ABA27714;
	Tue, 30 May 2023 16:09:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9E117AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:09:38 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7658411F;
	Tue, 30 May 2023 09:09:21 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UE4sLA008449;
	Tue, 30 May 2023 16:09:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=xN3ZcYmZO60fGAxWm/uNUS5AWPQszI7GkgGIgWdCdB0=;
 b=Y6E3N1vMx8pZWhozUQCbmS9B9tciFiu5Li80DeLP6EiKhl9KHXkH2FjrPmIw4W1DkHcC
 it2t29bDr4dld728vZyf7IFOPV+5FK841/r0TvwWpgD7zq+XFQkPUm1aRobMzCBxHM/A
 jkUxqJq7A5k1xeKI5mqrbm2HP8fShJ+0EZLdnuqzDHd0ZNLepwGQXpwpwkjpBDUnZUD0
 Wbe2zFvl1V+thzzx9+oayHHdDKAr4hgbS0zxa7mO8Pwr25cRvv2pmhPHGEsT9kFjybvd
 S1WEcAwrt3oAsmvXhHFbqL8dnhuc6vvFTibviagY3nhWuq7kb+SrYTwjABPXO7q4JlVV Dw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhmjk5yf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 16:09:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34UG3SSJ003698;
	Tue, 30 May 2023 16:09:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2045.outbound.protection.outlook.com [104.47.66.45])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qv4ybpnb0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 16:09:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQItupolu+XyEfwSUVoCid/HtRWLRZU8DZiTdRfeMbYyeYvcwcympIEsmezI/BMFKD4Iys2mWH6hbarBm5xWmEhZWTx8MPjHDEGJgxBcpyKR+trP+wgiDeNPGArmX8nI0nCihzAtjSYHod60IR57wxEjqkUhWgxsE/kqgO42OaZ45xB3j8DcDHbZIbm8fAnWJblQ8n7n+WoMMZ4LgPXi1OZecY+1mPezjyj8PDBOlXVxi1V3iJNQOG3vGLNLB/POL6ePDdUI81scF7jHmm8786gCpvWRQx2XQ1WRlflGTQDU94XTdoWaErcmJJdnifYE2tMsZvbZ1iNnBIvZBrtC3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xN3ZcYmZO60fGAxWm/uNUS5AWPQszI7GkgGIgWdCdB0=;
 b=AN983+XWwwr0GZ1dXr4Lpngyj3+6rCRlepXdW881z9QVeniSU8ckxYUiWpuyGaP6SIlFZszGAQMbxP0zxLTYN6QDSsT/a5VXFz6kB69Xydlg4CwSXvkS5VnVs9gVHC8+/hBbEI7k5BGE3Bfhk/V8QzG2yOMYEKF+Y9j9VkBqigIPncN2cOgdYujOXtI4PJBx1bL6P0EMEmBupgSqWYdzLaKUI0E1fIqwXrNiU2VZGgF0KUgw2VOOPz/QTtzcyKRroyS4r4zko+z40EsMC4jBY9nGjzCqrAf7v5v4g1bJpNvKzs9A0ham/kz8t/rcSTreITUkYjmGbGcxyTwcgicSbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xN3ZcYmZO60fGAxWm/uNUS5AWPQszI7GkgGIgWdCdB0=;
 b=cGvbWd+2wz0ApGPdETZmFunFG2CE2jgf4ZZRt8jGWcXep0DCSDkgX+R0SwY7e+4QFsPatt42LfV0aJWwVt/uJtihlE+02BoyEZDfohcyPjUX1KPCsMewnX+kmlmyhx7S3aItCWggaa3r71kGjiYzL8IhDPdXnnrV7bq8Dq8ffcA=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by SA1PR10MB5709.namprd10.prod.outlook.com (2603:10b6:806:23e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 16:09:12 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 16:09:12 +0000
Message-ID: <e4589879-1139-22cc-854f-fed22cc18693@oracle.com>
Date: Tue, 30 May 2023 11:09:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [syzbot] [kvm?] [net?] [virt?] general protection fault in
 vhost_work_queue
Content-Language: en-US
To: Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: syzbot <syzbot+d0d442c22fa8db45ff0e@syzkaller.appspotmail.com>,
        jasowang@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org, stefanha@redhat.com
References: <0000000000001777f605fce42c5f@google.com>
 <20230530072310-mutt-send-email-mst@kernel.org>
 <CAGxU2F7O7ef3mdvNXtiC0VtWiS2DMnoiGwSR=Z6SWbzqcrBF-g@mail.gmail.com>
 <CAGxU2F7HK5KRggiY7xnKHeXFRXJmqcKbjf3JnXC3mbmn9xqRtw@mail.gmail.com>
From: Mike Christie <michael.christie@oracle.com>
In-Reply-To: <CAGxU2F7HK5KRggiY7xnKHeXFRXJmqcKbjf3JnXC3mbmn9xqRtw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DS7PR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:8:57::13) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|SA1PR10MB5709:EE_
X-MS-Office365-Filtering-Correlation-Id: c6a478e2-3313-4f26-db87-08db6128350c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	s9iV58feiQgxCUq9VZknMCp30CUbFJ+olUGAlgYW0hbJnaPfmMkYgB9rww+xPAoelFPq3YhHAnBwmjKgyn8zuHcDGitKYsGKWiepaVNoVKQwETRFhymUwPFvRwT031roocnyGg+IvPq1HdD3w8ACwSzb+bDfdRc9L9lgfiA57qRtrlWz9gteA/fOZN7qSXWsgGjqQJmgkh+L74tmHi8Vr+cg0qrMDjJu4oA01ICZr741lnLWM2O1ucJFZeIdJZ1SHg+52Jmr7ZDeIHHcXajRnn+T0ZjlAZzy+yy7GZQnokgqlneNMWjPTXsJUh4wNi0273wT1LXjoBHl8GnU1TCfI7+XGM3yV5JzQqxQcOYF03pLk+5ztoKi0fUS1RZho3cAATUjvXAU5nvhQrTWHrpY6bx760vUPvotFysudAMHFiewBZPMYj5pjwQgENjck2GOIMYug3YbMHxpry3quVdisnIBSJ2DEfHxARH71SIygm6ooAIyJigLe7atn4XvMYNRcItw6hFw4uSm1Y2bnPDyj263QIaxHylINbqDbVCth0KieeRmpBM9hKOslwTt/xx9msXxwyOoV4ZgNYMyX+F4lx0yYlmzSd7ylaKO+BxQLGgRDeYyAoAdNvWgEqf7/5qnHWSqudLegE0a5IZ6BkXhrw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199021)(6512007)(6506007)(4744005)(31686004)(186003)(53546011)(2616005)(2906002)(110136005)(478600001)(26005)(8676002)(38100700002)(41300700001)(6486002)(8936002)(6666004)(66946007)(66476007)(66556008)(316002)(5660300002)(36756003)(86362001)(31696002)(7416002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?V2E3cGtKMGhuVXJyc3FkeE1PWTNqa0x4UDFTdllmQzBKU2ZzM2ZsSFJWZHNa?=
 =?utf-8?B?UlI1eGpGN3hHSWNQZTducnl2aTVqRHJaQzhtUlVGU0QydGlseEh2OFc1THUr?=
 =?utf-8?B?K0lyN1R0NVFtaFFqODdxQkh3TE9EZnVXNVR1TDFXakxxZnN4c09PSi9VTXZI?=
 =?utf-8?B?ZXpTWThsMFhPRjBzeE9JNitCaUFySXJnMTkzN3NROGZvZ1RkWVBidWxhUFBl?=
 =?utf-8?B?Qndja3ZMcG9kK1hlVk5CV0FxQkxCSkd0M1NEMUxFTmJZQnZJWk5HNXNVYlVZ?=
 =?utf-8?B?OXI3RGE4Z200anJqb2Q5SFZXa2diUm90N3BSNVBZaXF3QmFzbmNKRUo1SVV3?=
 =?utf-8?B?eU5UOEhkSHVKVzBSSEY2K0l3b1ZJRStkWFR2QkRXeSswaDY2QjI3NFgzSHI1?=
 =?utf-8?B?b2NCMktoYlRwczE4d2sySFMzR3ZjbXBsbFBncmsxdzlYNnlSYkRaUURrSW5I?=
 =?utf-8?B?Q2dxdlpnZ3VwQXpFM3luQzBqSmYzWVhHaVk2ZWNzVjNZVmwyR2VJYVoxa2FQ?=
 =?utf-8?B?Z2ZXRmdObmVIVzEwTmdaVTFNc2VNYWNUTTlqOGtxRzBHN3JyT0YyMkkwRTQ1?=
 =?utf-8?B?RDNMbEZJYlVPaHdpbWgyY2dZcllaTThwQjFIdEpLVEdKaFE1aVFvMlhiYndE?=
 =?utf-8?B?RG0wdnYvTWM1UE9ZSUpwazB5eW1XeDlZVkYwRzhQbGJtVVVQMktJY3pxV0lx?=
 =?utf-8?B?V2ZqQjJUVzB3c0crd0RZNkk3ZkY0SUFBWUpnTnQ4djU2NEF1N3JGNzJRRFda?=
 =?utf-8?B?a3FZQXRVN09iQ21OVWdpd2I2eUVNSkp4RXRiRXBMSVkyYXJwYWZZUU9QMXRn?=
 =?utf-8?B?SmNEQlFvb0VlSEVvckhobVlpR3JtenNZYUNhUVU0ei9JV2FlQ1B0SDhyQUhn?=
 =?utf-8?B?UGdGWC9lbWk0cGpMcTRRZWRGM2tkT0dOOE5pQnBvK3JTV0lPMnIreExlWGUx?=
 =?utf-8?B?L21rd1BBWnhmdU10K2JGa1MxMCtNY0dRbjdJRVFIaFBWUlYwbXYzeFhsRW1y?=
 =?utf-8?B?L3gzVlhrd3VuTEJremlwYytSUkNHcUVmcVV6V3VNN3RyQU1VSlVGVEV1K2RH?=
 =?utf-8?B?c1Z4OHZjS054bG12QUdsNGJ3dmhKTys1cjgvWjFQRU1xQ2xyemhuY2VOUFlp?=
 =?utf-8?B?NUY3NEFHZ0U5Z3hvc085QnJtbTUvbWV3bFpGOHIwZ1dKNmxWemRtRUc5Sk12?=
 =?utf-8?B?d0RhTXN5bHZCbmhGN1FaeFVsUHRoNWllOStwMWNVbUNHczVHeGdwSlhsZ3Y1?=
 =?utf-8?B?aUVlN0pNc1MwV0FkbkdsYWFsVWtyb09DYVlNTUZSWkFyOFp2WWVvdEwrQXM5?=
 =?utf-8?B?cW1OTXhFLzFVVWVvUUE1RC9jVWs3aElyNlBsK2ZDNW1ScFJpYlFEL1dJSVk3?=
 =?utf-8?B?YmpMR1drNGRxTjZ1NEhIM2FDaWRmQndUbCtSUFlpZmQ5SEtnbklvejVQSWQz?=
 =?utf-8?B?K2xxcXRWQ0NrSy85cGhYUlFOSWpodXVvYXdYVHhrNHJydmwvMGJNYjNqY3oz?=
 =?utf-8?B?ZVNKNDVoOFc2OTZKcjdrUHRjUkY4MjJzVFJIeXZhbWNXeE1nUmpUUUhTenlq?=
 =?utf-8?B?VDJ3MENoNXNla0V5THJHeWU1ZmNqdnJEaURlSmZzSldKQWV3SERBWWJVdjg5?=
 =?utf-8?B?dVcxTnVmazNSaFBLeTVMSFN4STNIRWVjZ3ZEb2VqWGtCdjI4YUs5VGcvRkwr?=
 =?utf-8?B?dGdXY1NyeUZkV0VmK3FzTEIzSFQyY0xzQ2pHR1ZUVmVCWXpmVStpbWEzQnN0?=
 =?utf-8?B?VEZlS2k1MkkvUFQ5MGZQUzZ1WU1lMDFET1lDblU3a3BwSkVFb0wyWVhLb09M?=
 =?utf-8?B?R2dwSlhrbVRUV3g2Rno3TVlkb09CZFQrU0wzdmE5dUtienZwTVpUTHJCdUsw?=
 =?utf-8?B?cURTOHNmamtLeHNhNnkwMWtxcW5wdTR3cVk4T2xDbEllc1hLZ1gwdmZJUElM?=
 =?utf-8?B?TDVFMDRiWlJXSjlsWnBObDZMVUZJK21EUTZSVFQ3aHZWcXlNWGU3dWhKakti?=
 =?utf-8?B?VTJYUitPUUtYcGtMNnowYktyUHg4ZVdqWVdMcEkvK3RNeWFHZXFMR3RIT3Rx?=
 =?utf-8?B?NUhUVjJubnFtZXFOcEd6czA3NXcwWUJ5Rm95MlRCTzVtYUdjUzhoM3FLL253?=
 =?utf-8?B?eUxZREJ3Y1JRaitEc2hZK1RzNnJ1Nk1KbGxkZkhLaG5LcHN6WDlMYzNvejJP?=
 =?utf-8?B?TlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?ci9MelRNSjU2U3pONEtUQUZncUJsNWNZa3YvUDZXV0I1Y1FJeE95RkpiWTlv?=
 =?utf-8?B?OGg5eGJCckVRZGt6Y3V3eXFBdzBpRSs3b200VjJoNGZ6eWJyWmdBVzlRRTdY?=
 =?utf-8?B?T0VBY2hab1pYdDNmN0U5ck9FQ2FmMkdMcDQ2MlpqWG5ob2Z1dmMxaFJtRkJB?=
 =?utf-8?B?TXF1WnRmTlpsOC83Z3VhazVJU3dYQVZlemYybGE0aEtQdkRZc2dpZ1cySVJj?=
 =?utf-8?B?cUlobDYwZTdWTXFpSGN2S1VLT2Z3QTJZR2czWkRwVGpTV2NsdzkrL0Z5dlRF?=
 =?utf-8?B?YVJ5Ym5Eb09sa0dUaU95OEVLS3Y0TWYrWitHQWNVZmxUOXE2enQ3dnlNOVBC?=
 =?utf-8?B?VFNPRXJkT0RLSXpsTlBXRzVTN2xvNDc2eHRCWE9mWmpBM25BNjNobnN3WXUw?=
 =?utf-8?B?KzZETnBkNjBRSk9weldnWlFqS3Rjci9iOHhDbjliYkhVZVhXaGtnMVh5by8r?=
 =?utf-8?B?Z0ozcjY1OTl1STFIWVdXVXVHemo0ZSt4eWVReFlnMGhjQ1dTZEREcU9SNkk4?=
 =?utf-8?B?R2dTYmdCQnFKOGI0YjZQQ1F6L05KU1ZEQ0hIcHcxaExTaDVRZHJiVnlhdkRF?=
 =?utf-8?B?WnhHUkc2ckV5NGhKUXRFVmRzTU13WC9FZ2VsV2xIOEtjeHFKRW1CQXBOTXNG?=
 =?utf-8?B?RWF3YU56OTgzR09IWEtiWTRDN3ViNTlEQWlvQkFrT0xBSTNvZkFqREdScFdu?=
 =?utf-8?B?UkF6MWpSZUF3MTlTbVJ0NXFJMnh6Y25zdGNCVm9WcHBHM1FsZ1FCa2k5Kzdm?=
 =?utf-8?B?RzQ0bWtuRnIwOHA2VXNCOVRrZDlaNHh5VUppVWpkb3FCUlVBVXRqTEwrVTZO?=
 =?utf-8?B?bUtpKzI0alBTd3hTMlZkNUVtR21nOUs5aEpxUGRrWmhrNXMxZjVWTDdrcmNk?=
 =?utf-8?B?TkJLR05kcExoaUdLTTBiTzhscWpEMnRDSzJmQXNSZWlBUllxV0NVdUlGaXBK?=
 =?utf-8?B?eFVUby93TS85SmxVWmluQWZkdnhaTlBjdXFjeHBueUN2dEpEQ2ZGQlRZNmZs?=
 =?utf-8?B?RDdhOEhJZCs5cldzemR5eFFHMmpkVHBBMDRxZnZMb0NWTW5VeFF1WnFGVkZG?=
 =?utf-8?B?VTFmUXVraDBCT0lnblM4MnZFL05uRFhzR2FST0Z3LzFOL0t1dDl6L2ZIVXdj?=
 =?utf-8?B?UVFzVndvS1hNRENRN3BwWWFUUUtZT1I4b2JSTVAwam92OXZHQkx1ckYrdGYr?=
 =?utf-8?B?MEIvWjdZZmRUb2hkeUpPSkpDK3VzdS9IaVdYTEhvVFh5ck02V1BxYjM1Z0Jn?=
 =?utf-8?B?Wk52SEdGc3FDaks4dUJjTHhxZ0MvLzA5SHRXdnV1c21zTitwemFuK3U1ZWlE?=
 =?utf-8?Q?pnbryLkrHDO0k=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c6a478e2-3313-4f26-db87-08db6128350c
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 16:09:12.0952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T83EcU00rN+1jqRcmiNunmiG3c6WXxsLQiyzVTUztli09a6/9Ny/cQ4j7iRdWu5uhzGbpDzIlDL+hTDlgV/V+d4rzeHm5X0j49xNser5bGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5709
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_12,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300128
X-Proofpoint-ORIG-GUID: etV_ONXphCRmSocuLiwEqjXcuwlPFteG
X-Proofpoint-GUID: etV_ONXphCRmSocuLiwEqjXcuwlPFteG
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/23 11:00 AM, Stefano Garzarella wrote:
> I think it is partially related to commit 6e890c5d5021 ("vhost: use
> vhost_tasks for worker threads") and commit 1a5f8090c6de ("vhost: move
> worker thread fields to new struct"). Maybe that commits just
> highlighted the issue and it was already existing.

See my mail about the crash. Agree with your analysis about worker->vtsk
not being set yet. It's a bug from my commit where I should have not set
it so early or I should be checking for

if (dev->worker && worker->vtsk)

instead of 

if (dev->worker)

One question about the behavior before my commit though and what we want in
the end going forward. Before that patch we would just drop work if
vhost_work_queue was called before VHOST_SET_OWNER. Was that correct/expected?

The call to vhost_work_queue in vhost_vsock_start was only seeing the
works queued after VHOST_SET_OWNER. Did you want works queued before that?


