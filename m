Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8654495602
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 22:35:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242667AbiATVfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 16:35:31 -0500
Received: from mail-sn1anam02on2060.outbound.protection.outlook.com ([40.107.96.60]:35790
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231373AbiATVfa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jan 2022 16:35:30 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TRRdVsWi1viDb9dGhauGBlGKbHdv7vRAku44SaynoUoop+s6JuFWm0vMN4OZY0VMms2oRPcvTwYiW9LMVg0fryQeW8mUzqSw0xgu8b+pxgHlN0xRNBp+cowyhLEAOErk6I+1ApUPSFz1xc8R5zy6GhmLk4TNceVV48cp6T61YI6rUijG/SaQ6EF9zDfn+k9G1oqSQMFa59uLGZJ6yJCdHDP2MriSchBgdIHwsNeS9JqhdOdA6akZMRUVB1o238A9gyBhyk2gS62qex39WKoFzj0Sl4byg1dxlAGxVARMa8LzRkm56rQS9GQ52mJ7BvYPT6na/HqFjg2dyTRkSbdO8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1Xb8IL40GuR8ynWkDCwxn9jEe9qVYYaX11bVtBYBxs=;
 b=lVLWQIaUcCSFpV5bryc4Gt14SQ+/HJPt+M5HD2eeaL/kaK+/W7rWDd6dN0APwIA5fDP2R4dH5b0rERR7K7Rm/9+zl5yO9xHCAawuIWAYwRUtHuo8x+rC0xdhyH2GUQsOrdnDV+GBFJbBjeOM/1vvMlVDbpOah6zoGyLUQ4x9ERlZ0IIuA5Ptq5NkSuA9OSnMJONvfLxBjeL1Eq5FF6IJ8dmzcUTQMcefu7h/2Rpy0gDr4gRjrVDzfLET5faHscoaXc5G3eC1XKtv68eJD2ru1cd3jPBfTNeK7DupyhpXKAa4Yz0ktZs+WkTXWra0H7MgQVABrtabtxLEPiX8mDTNgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1Xb8IL40GuR8ynWkDCwxn9jEe9qVYYaX11bVtBYBxs=;
 b=p/4YsRfy2x/fHOWXGFc3nDolGVqr/20sLL0q4cOcNB4F9rz3KlV7dQYgdiIZ1Pnn0dXjqUMA9GOguAIThCcZYruuBg88M613+ABDQ+zbaUuG1VPILFQx4oGa8nBtDX11p3/Slicf2tI/gO3cZRX1x4xt7YDkCw922E0jkW9Se8ibIGclGtCN+PblwZdL/mqhMMQcZu1m0esqVNzYoX5YX1qzXw0zPnSqPLjvsR5fLe2nYwGJLSzKELoKW1p3SjYlwu+KhUnFAWqdHY6u2NBK9bGYxNUpgFxuId7/r+Nx8KqqfmQL5UwCw6v+8SOGllS5pH2kveX2Z8GFUlBlHNxW4g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4140.namprd12.prod.outlook.com (2603:10b6:5:221::13)
 by MWHPR1201MB2559.namprd12.prod.outlook.com (2603:10b6:300:e0::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Thu, 20 Jan
 2022 21:35:26 +0000
Received: from DM6PR12MB4140.namprd12.prod.outlook.com
 ([fe80::ede5:7f12:c1:b25]) by DM6PR12MB4140.namprd12.prod.outlook.com
 ([fe80::ede5:7f12:c1:b25%7]) with mapi id 15.20.4888.014; Thu, 20 Jan 2022
 21:35:26 +0000
Message-ID: <a6b65260-669b-65d8-c20f-0d75e0393200@nvidia.com>
Date:   Thu, 20 Jan 2022 13:35:23 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: Phyr Starter
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Logan Gunthorpe <logang@deltatee.com>,
        Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, dri-devel@lists.freedesktop.org,
        nvdimm@lists.linux.dev
References: <YdyKWeU0HTv8m7wD@casper.infradead.org>
 <82989486-3780-f0aa-c13d-994e97d4ac89@nvidia.com>
 <20220120141219.GB11707@lst.de>
From:   John Hubbard <jhubbard@nvidia.com>
In-Reply-To: <20220120141219.GB11707@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0040.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::15) To DM6PR12MB4140.namprd12.prod.outlook.com
 (2603:10b6:5:221::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3a12c13-c6f5-4614-8d4b-08d9dc5cc5b6
X-MS-TrafficTypeDiagnostic: MWHPR1201MB2559:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB25595B65CE828B58F598DEF8A85A9@MWHPR1201MB2559.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5kf2HCFNx9Ji15uRIOnMmA/sbh8+Z25GzNBzuEyMA+lJ2JfZbHaBn3otlVrhYmnjnxnRYywLi+I0jUju7b3a2JvX15RTGj8XipzDeoCCoy1WKBTs19ShB8uorLzL1wac1zPduJr8sIYvIfToAynFfzG/g+CBAGtJZsuhkTjfZ1b82tmzN/7M786UvGLlyde3k60CfYO6h3YUfa/E2V6BQc7I53vnAIsTxjnLbQRnkqiS4oLxj2TYYeAN8Di2lQxv5Bo+uV4g4EOUqAl7soM39OSdGJ5SLxnH6YSW1mkiPxvBW32Hy0IBq0+zWbjeDbSaqVVQHDRqNe0Rqw+hICRlPyAOe8a9itrGfFZqcINWhLI6vsRM5bJ8NwxKCvMIgADvmzskFtCgWm3iX9ClDOdtMjq8NfqntvUCsAm0IZtv6hsWMpQY6zEXdB2Zh2wlwW/qr06oOXZwRtgN86mq6kB2EIbIonlRCv+zOabDMyA95qSqHNgwmdw0aXEFCWYarSKJWp3qcFHVW3KLNk7D2O108hngacPpiOVfUMEKpgfPjQoHc0/mZcBoJ1SCt2ho+Ch+i43jg/IPgDpYanlTr5TQuCVOy+77uwW5eLJLII2hvjS57puWRzOEi6PQt8GgGapsoa5r8H0oo5vJxawlJRRviFN8gDBomsQOQuuyjIB5ukb8JqzWQuJ3huiBrfxHey8dDnaGpWOSkrjquEISJLc7r+kvgxSkqn8bAA6KU6TpvBcsy1ncAxaOBZG53sb9GnJr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4140.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(7116003)(8676002)(316002)(66476007)(4326008)(186003)(6916009)(3480700007)(508600001)(66556008)(53546011)(31696002)(54906003)(31686004)(26005)(8936002)(6486002)(66946007)(2616005)(83380400001)(6506007)(86362001)(6512007)(2906002)(38100700002)(5660300002)(6666004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXpyTWRxRGNwdTRrbVRPRkMzakhZNDM1WkhxTllEd21YVEFZSUpVMkhvQnRY?=
 =?utf-8?B?bzdFK2dKNW4rTUhvZUJFMHkwNnl5K0FaNHlpVzNqTVpXL1dicVE4NWpEMm5u?=
 =?utf-8?B?UXYveUZlKy83RWZJb29oUGw1SENuM2E0Sk8vR0hBVnFmQSsxWHNGVFh2VHVQ?=
 =?utf-8?B?WHZZU0xiODE5QjEvQzNralZ4UUtaRDR0SWxDd2dUcHpCRXNBMWU2K1IwejRz?=
 =?utf-8?B?VVB2M2VUR2tXYm1ZbjF6bXY1RzlvWVBQRFhLNWhickNma3NLNTVQUXlGNERp?=
 =?utf-8?B?aFJrNHRYdmJRYkFuWlZaTVk5anBmUEE1TnNTZHdHN0ZSQ1FtNnpKQjhyN3dO?=
 =?utf-8?B?RWxGUlhJZFFsTGRNQ1gwVzNSVER4TkJBOVRISzdZazFFc1E5VGhIMGdIdi9l?=
 =?utf-8?B?ckxUQ2ZBWXJUSmUrMTBXNlhBeFBxVTlWeVZGZkpnUWo3WWQ3VGoyeEhmK1N5?=
 =?utf-8?B?UHV4VHN2QmFVOFFEK1RwcG5mTkxYTW9tMnc5SFhxbnRQQVdZU2RMSCtMSlRQ?=
 =?utf-8?B?SE9GU2JoL3dCV0JEUmVsZllVVVBlWjZCNmNzZ3JNQTdlcTJwSy9tMVZBN0Zm?=
 =?utf-8?B?MnFNb3JuaEp5MHlDUDIyVUMwbnY3ZDlOK0tZbHA4TVBsZnhoWC9VZWFmQjMr?=
 =?utf-8?B?ZTl1c2xvdnBiN3hFR29KMDczUVN2d01oa3F4ZzVOVEczblJJUjUzbHl3Ykp0?=
 =?utf-8?B?V2FaSFRoQ0JNdjN6ajRLVmNGMUpKdFRmWERvRklSVEYyaVBzK0cxQkJEdnR2?=
 =?utf-8?B?TFFyaC9Ebysyc1N4Q2V1ZHJhSHAzZ1hZVnNSeWdqUzl4WE10aVVUQWdvTFdK?=
 =?utf-8?B?K0hqMkx3R1E5UmZXMzcyWlZhYytxK2N3dGF4QTl1MnRFVHhGK0pRM2JKYWFO?=
 =?utf-8?B?L2FZQWRyblpKV2wzSHVDNFkrVW52UEp5NEc1WnVqK1Y1V1RvMGN5U0tXU3BO?=
 =?utf-8?B?Z0RDVHgyNFMwOFVpWVRUbmlPbW1pOEQwZUZtVlVDSFo0UFNEVHhha2h2N3Mr?=
 =?utf-8?B?OTBLVkQvMHpDMi9kQ1ZpOWpYQlhNdFZBMmwyYWk0NVdta1V1OGJ5U1ZEVThR?=
 =?utf-8?B?eEMrWmlZL3hFcVVvK0hOK2lqbmZ0d29nRkJuRXNRdDUxdDRXTGJKc2xHdTdp?=
 =?utf-8?B?OUd2Ukx6MmJrZ2lpVEVENzBjL2NoY1VYb01RWUMwbkxFRkwydzl2cU5wLzVS?=
 =?utf-8?B?d0J6QkhnSWtNZjNSTElmU05NenVNZ3k3WUFMZVVLR3FoWFR1MWxrOUhvZkUw?=
 =?utf-8?B?a0RiRGlTenRjK1RrYU5SKzVEbXR5alIxS25Jcm94amF6SUJYZ3JoS2hvTHNs?=
 =?utf-8?B?YVVDcVEzdUtwUHF6dnArSlhxN1g3d0xHVHRCV1I1RVYvZWlmeWpseXlPSGhy?=
 =?utf-8?B?ckp0akc0QnZucEFGQlVpa2VRYnVoUjdZMGF2WnJrTDJ4MzdpdVZ6ZUdlc2hZ?=
 =?utf-8?B?YmZsVVVwYXBUSERlMUZrM2xYNUVIOXRBR3F3LzdGSHYrNHVBTFVKQTIrME1X?=
 =?utf-8?B?Sk1NZ2YybWpqSVBuU1h0aG9qd2dRVWExUjlQdTJRM1RJcG56aTk0bW9qQ3oy?=
 =?utf-8?B?eC9RSERFeVJqcFdubUY1Z2M5c29xNzFabUpUd2Ixa0dBcUJUbzhZdGRqVEpt?=
 =?utf-8?B?aUlmOU40cngvS2RUZ3RYckpGb1EzbUQ2dVZhdndrRnVJYkJnM2sxcllrRmt4?=
 =?utf-8?B?bFJQVE0xWmZZNXYwd3lMNjkvcnJ5V3NCS2h6MVYyeXcraDNvam5QRmphbVVa?=
 =?utf-8?B?RGIzU2pqMm5iWEcvRWZNM3BNeEUraTVodjJKRTFpN2VSZEtaSld5Y09Zemp6?=
 =?utf-8?B?Q0txejBvSWQvMC9EVkg2Z2w2cTFsN1JnZXZ4aXZZaGFOOFdVNm55dTlEdVht?=
 =?utf-8?B?R2dPOXR6Z1MxQ3RqbGc4S01EK2JiblhIeEVWdVd4OGpDUm9HejFNUWY3bWxQ?=
 =?utf-8?B?UVBLNmREa3psaVI4NUhPanh3ZVV3VzArM2hKMmsyQkJvRFYwKy93R1IraGxu?=
 =?utf-8?B?bWZEYVc2ajdBdFRtU1V2OTlzQ0xxWHEyaDcrL3pUSkkxRG42dzRscVBBS1R6?=
 =?utf-8?B?eDU5RjV2NEM5ckd4Wnc2Rk0vNzJxUElZT1UwNFVOUExoSm8yTWxjZUtmV3Zv?=
 =?utf-8?B?MkJ2aDhrclVnbGRtMS9tQ1lGTEhOb3JIM0ttTkdmaDdVQTdmby9oTDdCczJF?=
 =?utf-8?Q?vrHX+Tr7yOc6e5MYPqF8+KM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3a12c13-c6f5-4614-8d4b-08d9dc5cc5b6
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4140.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 21:35:26.4325
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4WjzFTIwbIds3SUEgIVBXKvy0ozCxfD+csRsUdXbj2XoYyOHEUVAaEHzQSWS5DV3Z3Aa/APuSxbzmLMhaQIpAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB2559
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/20/22 6:12 AM, Christoph Hellwig wrote:
> On Tue, Jan 11, 2022 at 12:17:18AM -0800, John Hubbard wrote:
>> Zooming in on the pinning aspect for a moment: last time I attempted to
>> convert O_DIRECT callers from gup to pup, I recall wanting very much to
>> record, in each bio_vec, whether these pages were acquired via FOLL_PIN,
>> or some non-FOLL_PIN method. Because at the end of the IO, it is not
>> easy to disentangle which pages require put_page() and which require
>> unpin_user_page*().
> 
> I don't think that is a problem.  Pinning only need to happen for
> ITER_IOVEC, and the only non-user pages there is the ZERO_PAGE added
> for padding that can be special cased.

I am really glad to hear you say that. Because I just worked through it
again in detail yesterday (including your and others' old emails about
this), and tentatively reached the same conclusion from seeing the call 
paths. But I wanted to confirm with someone who actually knows this code 
well, and that's not me. :)

Things like dio_refill_pages() are mixing in the zero page, but like you 
say, that can be handled. I have a few ideas for that.

Now that the goal is a considerably narrower as compared to in 2019 
("convert DIO callers to pup", instead of "convert the world to pup", 
ha), this looks quite feasible after all.


thanks,
-- 
John Hubbard
NVIDIA
