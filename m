Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED653C8128
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 11:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238786AbhGNJQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 05:16:40 -0400
Received: from mga14.intel.com ([192.55.52.115]:12621 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238811AbhGNJQ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Jul 2021 05:16:26 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10044"; a="210130902"
X-IronPort-AV: E=Sophos;i="5.84,238,1620716400"; 
   d="scan'208";a="210130902"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2021 02:13:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,238,1620716400"; 
   d="scan'208";a="494121467"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga001.jf.intel.com with ESMTP; 14 Jul 2021 02:13:33 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 02:13:33 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 14 Jul 2021 02:13:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 14 Jul 2021 02:13:32 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 14 Jul 2021 02:13:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EmThlMkOOHI5iJIiNQfmhftUPiosoWpC6HetzCR6lpqGw1kxn1Hvbb3x2g9ppYpD+3GmF43yo39Jx53sqBB3RGs9e/nc1rMkRi6SUb2GOzrTa6QIp6+Fyc5q7jMwIKI8yLtoBNVZVCecB+PzwDANmJTBdqijA7ZVAXJcZeQ58y1U3Agb0EMo1BCk9A1G6ZG2Pqzd6I/ybKde63WKb27wbsbODlLxuZ9HiFKPTBKN2COItpzTEav6vlFT5/RLtpJ8ptIqKLv8YtJMF5/e1urd5z5mc7XA7tD/XM0IZcqic6iflZ3GEPU6z+Ht1SBfS+Rr9Ulwn1zeMPMPCJ558XWjZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07/0c2IDXV/uujf0xKKLvhp7wQXQYAPs5QFnoJcHhVI=;
 b=lQl7sQX6RNLc9aOTDd9by3KfwfVL12ynWAKLggod6CYFOiEbB3hqDqZdUJxGKyTL98gs9sCvDSlraJZkokydhEPr/947vxQrQwY48AEhfKXJLvtv8hJvo7FCx3MyYN+zrVRweDhNgYIQvwQCxEC1XbqgxI4qixDTsgVl+t5QnRWUd2UnmvrlSLyXDYlM5gzyJXNXr8PXq9BH3uDCPqcHMeesKxqh6LMfy8jDpCIw9PFin6wbSrFECrxV4bXGrNu425hlaX5ZF1H8/tAqM6MAorZF6RGtHMLaLeEUgNEQ3cf0tflM3HfNXsPShZfZcEZotoYoYkfmY3BsQvsP/BRapw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=07/0c2IDXV/uujf0xKKLvhp7wQXQYAPs5QFnoJcHhVI=;
 b=NTBRGrtBlz0T0XnfBMxHfmWKGC3WtoWYZ+I9inMKixf9x+HY3NG1m+VZLtdAeP1JcJ0N+YGoF6lvRpV50j+PqmEGcJzM5nTUMp/bwlUB4oXLtzCuoMwjEzVFSmwLL6nvcLcyqRjfiGqfEDy7ra9m3iFSIpxPfEEaNTbDtRLkcEY=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3162.namprd11.prod.outlook.com (2603:10b6:5:55::27) by
 DM6PR11MB4361.namprd11.prod.outlook.com (2603:10b6:5:1df::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4308.22; Wed, 14 Jul 2021 09:13:31 +0000
Received: from DM6PR11MB3162.namprd11.prod.outlook.com
 ([fe80::10e7:c9b:7541:aa95]) by DM6PR11MB3162.namprd11.prod.outlook.com
 ([fe80::10e7:c9b:7541:aa95%7]) with mapi id 15.20.4308.027; Wed, 14 Jul 2021
 09:13:31 +0000
Subject: Re: [Intel-wired-lan] [PATCH 2/2] igc: wait for the MAC copy when
 enabled MAC passthrough
To:     Aaron Ma <aaron.ma@canonical.com>,
        "Neftin, Sasha" <sasha.neftin@intel.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Edri, Michael" <michael.edri@intel.com>,
        "Shalev, Avi" <avi.shalev@intel.com>
References: <20210702045120.22855-1-aaron.ma@canonical.com>
 <20210702045120.22855-2-aaron.ma@canonical.com>
 <613e2106-940a-49ed-6621-0bb00bc7dca5@intel.com>
 <ad3d2d01-1d0a-8887-b057-e6a9531a05f4@canonical.com>
 <f9f9408e-9ba3-7ed9-acc2-1c71913b04f0@intel.com>
 <96106dfe-9844-1d9d-d865-619d78a0d150@canonical.com>
 <47117935-10d6-98e0-5894-ba104912ce25@intel.com>
 <1a539d4d-10b4-5b9b-31e7-6aec57120356@canonical.com>
From:   "Ruinskiy, Dima" <dima.ruinskiy@intel.com>
Message-ID: <20daa122-aaec-0c6b-23f5-d2be2fcab1e9@intel.com>
Date:   Wed, 14 Jul 2021 12:13:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
In-Reply-To: <1a539d4d-10b4-5b9b-31e7-6aec57120356@canonical.com>
Content-Language: en-US
X-ClientProxiedBy: PR3P191CA0034.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:102:55::9) To DM6PR11MB3162.namprd11.prod.outlook.com
 (2603:10b6:5:55::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.126.210] (109.226.49.158) by PR3P191CA0034.EURP191.PROD.OUTLOOK.COM (2603:10a6:102:55::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23 via Frontend Transport; Wed, 14 Jul 2021 09:13:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54230103-a439-4de4-0401-08d946a7a63c
X-MS-TrafficTypeDiagnostic: DM6PR11MB4361:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR11MB4361BEA63614D26371537204E8139@DM6PR11MB4361.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l3uJWv49SuyLiQYzqeuYLocIQvkIeacW9ZGIGh55v1nfk9nGF7ReI5SRK/8KFfOAWny9LSzP/cBk4A+oTduQrp6CTWDhRqUsrd4m9F6YpAZ0DKrm2Vl3VaW/XfOM8meh2r2Srsv7aeX5wRid6Ra2P0Kd0lJkFSWns80fmISVlrIjwsOdViw3gKowzzGN3Xh6hziRf1+xDMN+BVkfftk5tJKYHbg030zUHsjp/kSlTISHWzJ/6+PL8iiCLRdiYqeeCPFFxR7SvNabd3zrcS5+Z9PqhG9kW7kcZKtSTbyoHwgGPRVitLRL+nS564+JuYBAwi09Fm+hi+ju9uyMBv859rYjOVCpP+yU/yt9XFEkYGliXH1E2QQtJOvy9QAQn9n/4icar4gE9GtyXLWlDYC8MnPY6E5of8YHLaas8Dn/HkQKAqmeWtiGSMNvUD0YXBb8tcScoMkPC6Zz2zZ3jHhSvn6GpkIWdfFF4Ii5axZQLcx/sUJA/ZbVXDY5h8yUWfs30txMzvN9Tfbhg0recoYfMxbb8qPce29wWVAGh4sXMfaGvZoozT4eJseOlWz33F2LWkX4HKhVOx2OOcxk9aFwApxXTq0iwk9lUAbndPNyEqDcL6FBAiJPAqoEJt3dqbmtkVwNY69C/v0fglGbGG+MANT7mXiX1Gm7EGzp6K041ezORR/rBi7OJ8D0x+ybhOabXzKXgRlaZJeKmzzP8fuIj5VNwcKSNQpo+JY2dahx7FYk67DVr0p0tfNghW+aQCFx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3162.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(346002)(136003)(396003)(39860400002)(921005)(186003)(2906002)(26005)(478600001)(66556008)(31696002)(36756003)(6666004)(31686004)(110136005)(8676002)(66476007)(956004)(6486002)(6636002)(83380400001)(53546011)(66946007)(38100700002)(316002)(2616005)(16576012)(5660300002)(8936002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aThpdmZNT1FGRHpudDR0aHVJTVBJeTJEejludXphZVM0Rklwd1RWWWJkNWxx?=
 =?utf-8?B?TzZpVCt3L0NrNG5rbDQrNGJxL01ZT3gvbHZVN1Z0ODh5QkxjMFZoQUR6SXoz?=
 =?utf-8?B?b1RjNlFMdnREbDJUdzN1M2lzdmMvbDlrVVJ0MW9OamtiNnFtQnRwSVVWTlY1?=
 =?utf-8?B?ZTk3OXZ3Y0cyVm81eWt1WkFaOTNrZnpaQWUyeXpUbnBocWdKTlRoRlhSQ0VB?=
 =?utf-8?B?aG9hMUk4SGwvOXNvYWNPdmRObC9NcVliT1hQTE1IRkRwZ2hiT2t0RTlLbVVu?=
 =?utf-8?B?QkIyV21aR2pGY2tQL01sMDc1NjJmSEZuLzNqR25mNVFsWGFDYlJ0MHRRcllm?=
 =?utf-8?B?NTlCM1VxQy9XVGVGeHVielEvR2xyeGduNmhOZUxuWU53eTN5d3hkT1ZzalAw?=
 =?utf-8?B?U0YyNW5TUlNsZHpXem1EWVlWYWVFS1NtYmU2OHh0Skp0S2dDWUtPaVRzc0RH?=
 =?utf-8?B?ZG42VFUzREpmemNwQnZmWTh4aDhHRHdmbjVhVVVCUjg1NDEyNWJPYjN1Nnli?=
 =?utf-8?B?K0R6U2FiM1lEVHo3MU9DMGpPclRROWE2Y21BQ1pYZWdhU0FNODVLa2tvaFFz?=
 =?utf-8?B?T0MySTQrVmRyUTJFTTVGUHhUYUNKOWFQblBsWHArUGY3SXJWOTl5Zk5tclE2?=
 =?utf-8?B?Um5GYTRKbjBQK3l1aDVCRk9aRytnYlQ5VnhhVHZKeU9wUVZaMlpCVkhKLzhZ?=
 =?utf-8?B?U1F5VmUvdUtJcHZ5NmFGelNzZDA3ZE5rbVFlbitCM0hQcEFwMlNrTVpRdTBZ?=
 =?utf-8?B?bnZ0ZDQrNzFwR1p2NFdMaE1oTS9NYTNvVmJWb21UendNekpodVlUdktmeXho?=
 =?utf-8?B?NExpUmNCUGJoSWowK3Y4WllJVlJUbGhTWHM0bEE1dzhtZ25QcXBLT0x4ZWpR?=
 =?utf-8?B?eXZheWcvK0VNTmtCS2ltaGdnNmNGcEwxZXczSHRJOW9yK3RQSWhDZ2NGQlBp?=
 =?utf-8?B?MWdXTW9BRWkwVUNvZFJOT0xEK2w3NzdKNU5sTUVZc2hmdGxKOXpZUXFoYWwx?=
 =?utf-8?B?V3NBZEJkVDFCZW94U3ZIUUNib3FOZngzSE5zbTlZME5TcXU1aWZ6S3RpeTRT?=
 =?utf-8?B?dHpvZ3B1OGlLNHFTVWNDRU9PWTRxeHhjNi8yRGdIeFBsNnBCVS9GdGprYUND?=
 =?utf-8?B?eDhFWGVzWFBhNmVqaDdiaXcxNXBETlhDOFQ4b0NtVWUzbzBDM2lseVByMFlR?=
 =?utf-8?B?WFh0M21vZlFaOUQzZGlzYVd2enlXMnE3S1hITHJ0NU16c3p2SWZ5Z3FPZHA1?=
 =?utf-8?B?KzdyaXc0Z29KaGFsSTBNVGZYL2o3c3NqV3lleXMvUzFXbXdwN0szTTU1RDMz?=
 =?utf-8?B?NHhEb0hjczBlZ21BUytsVUE4cFRtRk5KUm1xb1V4TGNPQ3ZpRzhRUnJMMWhw?=
 =?utf-8?B?SERlcGxrejFPWmJtTEQwdWo5Mk0rdUwwdk81N1pRM01jUUIrVlBpQm9aQW9n?=
 =?utf-8?B?SFVqYnQ2RGJVdEVLL21RNWRINnN0aGF0UFVIc00rMlB1SDlhcTZYSHVVK0xS?=
 =?utf-8?B?TE0rMDE5djNrRlhOSDV5aG5ZaDlycHR4NC95OGlqSnQyTW5uWFRHb3h5WVRM?=
 =?utf-8?B?aXM3dDZwamJNeG9WaW5DOFY3OVBpRFdEYW1RYnFoN2E0ZnZidTNHVWJMUnh5?=
 =?utf-8?B?WnVPNWk0MWtFdGVvdTRMR2JjeVIzMVdMYUIzWWplc1pvUTdTaWVmaWxycDJ5?=
 =?utf-8?B?OVRHNHlPQ21IUlg2M1NDY1ZXZTYva21UdkpsaWdENXZiSmNCSVE1YlFjNUo2?=
 =?utf-8?Q?t4tEsTKcKe4v7Ia7I/zKPGX+4oCvO9YWcOySbKB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 54230103-a439-4de4-0401-08d946a7a63c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3162.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2021 09:13:31.3328
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rUTL1bYQAYZObgPXbU1BsZUlpTVJnnr+ylgqg3VCJEKzr8tGlVYCwdqJlb8WJltvWClSEdc82UAQ5KZKRI5swA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4361
X-OriginatorOrg: intel.com
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sIEFhcm9uLCBTYXNoYSwKCk9uIDEzLzA3LzIwMjEgMTY6NDUsIEFhcm9uIE1hIHdyb3Rl
Ogo+IAo+IE9uIDcvOC8yMSAxMjoyNCBQTSwgTmVmdGluLCBTYXNoYSB3cm90ZToKPj4gScKgd291
bGTCoHRvwqBsaWtlwqBzdWdnZXN0wqBjaGVja2luZ8KgdGhlwqBmb2xsb3dpbmfCoGRpcmVjdGlv
bjoKPj4gMS4gcHJpbmNpcGFsIHF1ZXN0aW9uOiBjYW4gd2UgdXBkYXRlIHRoZSBuZXRkZXYgZGV2
aWNlIGFkZHJlc3MgYWZ0ZXIgCj4+IGl0IGlzwqBhbHJlYWR5wqBzZXTCoGR1cmluZ8KgcHJvYmU/
wqBJwqBtZWFudMKgcGVyZm9ybcKgYW5vdGhlcjoKPj4gbWVtY3B5KG5ldGRldi0+ZGV2X2FkZHIs
wqBody0+bWFjLmFkZHIswqBuZXRkZXYtPmFkZHJfbGVuKcKgdXDCoHRvwqBkZW1hbmQKPiAKPiBV
cGRhdGluZyBNQUMgYWRkciBtYXkgd29yay4KPiBFdmVuIGF0IHRoZSBlbmQgb2YgcHJvYmUsIGl0
IHN0aWxsIGdvdCB0aGUgd3JvbmcgTUFDIGFkZHJlc3MsIGRlbGF5IGlzIAo+IHN0aWxsIG5lZWRl
ZC4KPiAKPiBBYXJvbgo+IAo+PiAyLiBXZSBuZWVkIHRvIHdvcmsgd2l0aCBJbnRlbCdzIGZpcm13
YXJlIGVuZ2luZWVyL2dyb3VwIGFuZCBkZWZpbmUgdGhlIAo+PiBtZXNzYWdlL2V2ZW50OsKgTUFD
wqBhZGRyZXNzaXPCoGNoYW5nZWTCoGFuZMKgc2hvdWxkwqBiZcKgdXBkYXRlZC4KPj4gQXMgSSBr
bm93IE1ORyBGVyB1cGRhdGVzIHNoYWRvdyByZWdpc3RlcnMuIFNpbmNlIHNoYWRvdyByZWdpc3Rl
cnMgYXJlIAo+PiBkaWZmZXJlbnQgZnJvbSBSQUwvUkFIIHJlZ2lzdGVycyAtIGl0IGNvdWxkIGJl
IGEgbm90aWZpY2F0aW9uIHRoYXQgdGhlIAo+PiBNQUPCoGFkZHJlc3PCoGNoYW5nZWQuwqBMZXQn
c8KgY2hlY2vCoGl0LgoKVGhlcmUgaXMgYW4gaW50ZXJydXB0IHdoaWNoIHRoZSBGVyBjYW4gaXNz
dWUgdG8gdGhlIGRyaXZlciB0byBpbmRpY2F0ZSAKdGhhdCBNQUMgYWRkcmVzcyBoYXMgYmVlbiBj
aGFuZ2VkLiBBdCB0aGF0IHBvaW50IHRoZSBkcml2ZXIgY2FuIHVwZGF0ZSAKdGhlIE1BQyBpbiBp
dHMgaW50ZXJuYWwgc3RydWN0dXJlcy4KClRoZSBpbXBvcnRhbnQgcXVlc3Rpb24gaXMgLSBpcyB0
aGVyZSBhd2F5IHRvIHVwZGF0ZSB0aGUgT1Mgc3RydWN0dXJlcyBhdCAKdGhhdCBwb2ludCBzbyB0
aGF0IHRoZSBNQUMgYWRkcmVzcyBjaGFuZ2UgcHJvcGFnYXRlcyB0aHJvdWdoIGFsbCB0aGUgCm5l
dHdvcmsgc3RhY2suIFNvbWUgbmV0d29yayBzdGFja3MgZG8gbm90IHN1cHBvcnQgc3VjaCBhbiB1
cGRhdGUsIGV4Y2VwdCAKZHVyaW5nIGRldmljZSBpbml0aWFsaXphdGlvbiAocHJvYmUpLCBzbyBp
biBzdWNoIGVudmlyb25tZW50cyBhIGRlbGF5IGlzIAp0aGUgb25seSB3b3JrYXJvdW5kLCBhbmQg
aXQgaXMgYSBwcm9ibGVtYXRpYyBvbmUgYXMgd2Uga25vdy4KCklmIHdlIGZpbmQgYSBtZWNoYW5p
c20gYnkgd2hpY2ggdGhlIGRldmljZSBkcml2ZXIgY2FuIHRlbGwgdGhlIExpbnV4IApuZXR3b3Jr
IHN0YWNrIC0gIk15IE1BQyBhZGRyZXNzIGhhcyBjaGFuZ2VkOyBwbGVhc2UgdXBkYXRlIGl0Iiwg
d2UgY2FuIAppbXBsZW1lbnQgaXQgZGlmZmVyZW50bHksIGFuZCBub3QgbmVlZCB0aGlzIGRlbGF5
LiBXaG8gY2FuIGhlbHAgdXMgd2l0aCAKdGhpcyBpbnF1aXJ5PwoKVGhhbmtzLAotLURpbWEKLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tCkludGVsIElzcmFlbCAoNzQpIExpbWl0ZWQKClRoaXMgZS1tYWlsIGFuZCBhbnkg
YXR0YWNobWVudHMgbWF5IGNvbnRhaW4gY29uZmlkZW50aWFsIG1hdGVyaWFsIGZvcgp0aGUgc29s
ZSB1c2Ugb2YgdGhlIGludGVuZGVkIHJlY2lwaWVudChzKS4gQW55IHJldmlldyBvciBkaXN0cmli
dXRpb24KYnkgb3RoZXJzIGlzIHN0cmljdGx5IHByb2hpYml0ZWQuIElmIHlvdSBhcmUgbm90IHRo
ZSBpbnRlbmRlZApyZWNpcGllbnQsIHBsZWFzZSBjb250YWN0IHRoZSBzZW5kZXIgYW5kIGRlbGV0
ZSBhbGwgY29waWVzLgo=

