Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE463F618C
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 17:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238320AbhHXPZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 11:25:21 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:32672 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238245AbhHXPZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 11:25:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1629818674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z9BB9UGbJaV8rw1zPPuxCWxYQ8f2EjiX1JJeVB7tOik=;
        b=HX72X8OlU/m4JtRjvIFZJz+KfH/VrK4KFLtzScSqGspZ1RKGet3pWO84/9Jn1tsGvvHF+3
        bpuWCCT+cLBbz3qYDeRWxhJMp1qsVAPt7QYHkfe9SjusVfcPu2xHP7ELQsGCYx+e0K5Y0j
        KIsKedB+xoJi3wthKW31hk1LHBdEAek=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2173.outbound.protection.outlook.com [104.47.17.173])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-30-zGN7UektPUuyjOUhxh0nHQ-1; Tue, 24 Aug 2021 17:24:33 +0200
X-MC-Unique: zGN7UektPUuyjOUhxh0nHQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DCKm4fKYDYI2FOT5wF7y3uIqzFpjXhvZ5rrGgAxnWnvHgIVixsfw0IINFV0OzVYlO7D7TPoeIzF9v8Bh8rcVH8WJD0q/3fwPZIWpN3WGKFv2TTfHlWl4QM2mfkSZrOkh0vHEVIuKUvDu85l7/Kf2uvYgeboVEBtSdDM08zRYIVbJpPLrDG2m1F4Jj86w0x5DeDlGGxrxBCAWXGSpNGnXXIuxvHeBxdeh2/64Qq2/tB4o1t3PY1laXgUNE1zn+x7Kh8FkRg9pPZjRgg6kYotlpQ3R7e1NXyD3Eeviq5WUgTIcRXAGXYMbfjEOP9vJUzyBZ583xNVhpQzbBJdeswqD8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9BB9UGbJaV8rw1zPPuxCWxYQ8f2EjiX1JJeVB7tOik=;
 b=fG03s95B+RDAoQo6raY02ZirExwOdT4OjxgicRqZDvogFErrjnlvOBBJiQD6ee7uRvaDLbeXmHid+vRzLOQaDupISDFRclZ5cWha8m4glhdxz20d6piN3z8dEsOHuRpUQPemTYR8fN3clxt5KvolvZHSJ4Zp8t44cu+JhZ5Jr4CAZuQYUnyTYAQN2Ql4WMYei1rWB3WkoKclYsH8QzfLJllDOtq5zCo/hMqifsLorZueur13DHriHb7uyr86oybexq/lvdOq6dDFXn4L8mIAaWPxEiYJp8hg0g3mYsIAZ26dNmdlegjcOduF98895OPw8/d970oAAJPnZG0IQR7sOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5587.eurprd04.prod.outlook.com (2603:10a6:208:125::12)
 by AM0PR04MB5218.eurprd04.prod.outlook.com (2603:10a6:208:c4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 15:24:32 +0000
Received: from AM0PR04MB5587.eurprd04.prod.outlook.com
 ([fe80::4822:460f:7561:33bf]) by AM0PR04MB5587.eurprd04.prod.outlook.com
 ([fe80::4822:460f:7561:33bf%5]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 15:24:32 +0000
Subject: Re: [PATCH v2 2/4] xen/netfront: don't read data from request on the
 ring page
To:     Juergen Gross <jgross@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210824102809.26370-1-jgross@suse.com>
 <20210824102809.26370-3-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
Message-ID: <9ca2d6a2-03a5-ff4e-8d20-dfad9cd14e4f@suse.com>
Date:   Tue, 24 Aug 2021 17:24:30 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <20210824102809.26370-3-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR3P189CA0040.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::15) To AM0PR04MB5587.eurprd04.prod.outlook.com
 (2603:10a6:208:125::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.156.60.236] (37.24.206.209) by PR3P189CA0040.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:53::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 15:24:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3ebcb00-4987-4762-400d-08d9671345c5
X-MS-TrafficTypeDiagnostic: AM0PR04MB5218:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB521875D6A8E5A5998AB9487AB3C59@AM0PR04MB5218.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3NLlGJyaNs4KiAZzCU8qZ8g+AohI3Vowr+YXBOpmGn6yRFZbWXol4kJMYxBFdWABR6b8u7sky9dK3Fr+hDVd2tRHu66U0xrSSkKaWbE2K7gkV0+a9IaWORlHMLEHD5lWh4qvUo2k5VHapr/L2fEataZIBXubdyRyczg+0HzxNGnCOo64X3Krm2xXTTao1l+SaYcQkNs0JHNKSfsh4nMO3PoFLjMCN07cmaFZYGslQwy0uDYFqHK/7Sj4LsEZB+3MAGagzxtNSZ0/jliv8M+SftXKuZvnN0PxI5cD2U0HUpFxPjYf93VKodTG5VnWIiq3GtH4uGxkbB+HL0rFfb2QAD0bkNxV7LWkU1rNl24jx7qt1JNPFkunBsOMSbDvdKiLG6cvtqaCq4XPdFL+afCeGyeXEkbPj95xltQGqaW4DlMIPBR/vuC/NJLXkqI6Gbgv+eYvEw/mavMRMjBPDDe8gDqhzid+DqVEaWk1GD/A7o6iF5fqJ3WEAobc3OwtYrucb1wZTx9ROzzFqEm67N1D7ZyprhH2vjRLjP2Uii4cxYfDknvtX00j3VJ6W6QjyCY3+nh5UY0qeHzLiLU5o8CtNp08KAr8RgyyYRku1K6VfN9TRHn+K3pX4l7BN3b5P8DIFUPN8WWR7FOrpBZMJKmx7taAvxoGF7wbfFORo24t/XLZzoHLOLR8aT9t62kJD0ACy0F/xe8hxjJKwvenEVYEK85otRAyK4W15Lb/xverzJg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5587.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(366004)(39860400002)(396003)(316002)(5660300002)(26005)(6862004)(4326008)(4744005)(8936002)(83380400001)(31686004)(66556008)(36756003)(16576012)(478600001)(66946007)(8676002)(54906003)(37006003)(6636002)(53546011)(6486002)(2906002)(38100700002)(956004)(2616005)(66476007)(86362001)(31696002)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ly8vZHNOTXVBQjNpc0NocXNNWm5TZVpnY1BESU5maE1KVTh3MVQ5QUJzMXpa?=
 =?utf-8?B?emhlQldHejAzQ0VCNlJxdm9wYUZTQ05qWGZ2aHlMZlkzazhzbVNJN251Y3hP?=
 =?utf-8?B?SGxUVndWV0lXTzM4YVJVUytqaVBFOVZZdFFNTUZyUktRdUdXZTRVNEoySnlT?=
 =?utf-8?B?d0pERlpoQWlaOHJSSEx3VzVkUjNrVVJENGFPYTdKUUlKaEFpc3dKUTNRNnow?=
 =?utf-8?B?UHoxWFdEWEpiUHBidUpoQUJyMEd4aHZ6M2M2WnE0S3gyOXZiN2c4OXUrYXd0?=
 =?utf-8?B?VmRzVk5iZFMzbnE0VlFHci80eE1hS1IvRVRMWWNzTzdtVTRnZm93S3kzd2Fl?=
 =?utf-8?B?bG1EYkdEVExnUGFMa2NROWl6cVN6dXpkQzhDVnhTTkw1RkNkOXh2amp3eG1v?=
 =?utf-8?B?bWpZYVgxbFlFV1VDL3k3czJ4b3k3SEdrWmZjUDVKNVVsOTAwUzBOd0pGOU1m?=
 =?utf-8?B?L21IdGc0T3Z3YkVxRE9wbjBoajRzSXVmNnN5RGl2T2JaR1M2STdseS80RjFV?=
 =?utf-8?B?UThCTXh0THNKNGpDVFNZUG40Skd1aUlTWnIxV2ZnQnJPU0JkNGFmcXhKOWZ4?=
 =?utf-8?B?Kys3YUdTWVNRR0daMlVJOUMzN0pERnVZSk5Hd3FOVk9XeWdtS3luQTV3ajY1?=
 =?utf-8?B?UWRFL3pKUWU1WU44dzd2eC9sZlVhTHhxVE5TMC93ZVJKN0Q1ckF5S1FiTm8x?=
 =?utf-8?B?Zi8xTlIzQ1VzaG9lcHRDNktJdGx6MEtEZ0dseHdYeU0yeGlpS2Jic1FLbzUw?=
 =?utf-8?B?V1N0OHhDTTB1b2o0OEFhZG8wajhRL3M1NzdyUFZBdU1GRGhzVjZBdkdVSElL?=
 =?utf-8?B?clgycy9EL3pMU0c2ZVVrdmVOMlNlTWdzdE9Od3pOclozb2NONEpMQlBzeHBh?=
 =?utf-8?B?NXcvOG5abGttd3RrdW1Gc0g1K2hMZ3RNdHpRQlg2UTBKVjNiTjh4MDN3WFFH?=
 =?utf-8?B?d0hiSXNWU2lNNzl6UVpwejY5dGdFQjNXS1cyaXB3UXVUdFhHOUJMa1hzM0dp?=
 =?utf-8?B?aWNQclF0RDlxMkxzeUY4dWZHK1prMy95WVlqbGlEcnBadFkvVTdsU0EySjNZ?=
 =?utf-8?B?dnp0NHlLTTZPRkJGQUtKRzZ6dDhpeGF6YlRxdDF4c2IyUmIyeWFOcUg5UEIz?=
 =?utf-8?B?akx2MVV4b2VxWHVTcEovNllTWWNnVS9BaGZUQzFjR1JMTmRuclM0UlI4QVFr?=
 =?utf-8?B?V2ZQN0dHOXh5TEhhanZHTW1XVE1aNWFwTFo1QzRteVVkTTZlb1BKVVNFbWw4?=
 =?utf-8?B?M2hsMXRTRGlvN1dRS1o3UlJUaXc2U1NHcXliUFFSdXdKVCtyZ0RiVnN3cFFs?=
 =?utf-8?B?bEtmRElrbHhSTXhOaHRqLzZRZ0hpZHBNRkwzSFkrVWJNNmR2dkVCektPeGhz?=
 =?utf-8?B?eVZwSS9vOXRsKytjZklFTHVZNjUrTmpOZjFFTE9aRGFvY0JYaU00K2U0RWE4?=
 =?utf-8?B?Z0w1RnpicEVGWkRsTmMxTkVGUXJLT3NZRWpCMVhqWnZYdk5EK1doZlJBcnps?=
 =?utf-8?B?c2pPQnBSK3d3dWhhQXlCOEg5RGZuSEpkalVCWjFrdkg1YjA3UFZwcTlpY2Mv?=
 =?utf-8?B?Q2VVZXhrek5scktxczVlVXJueXc4bVFqTGZvNDE5UHpXdmE2QW9FeDhoTGEr?=
 =?utf-8?B?UGFjYjdMdVhwNXljZ1Y3QmZXNjNyanRBQU50c2lHV0VwaDJmaW55eWZvWXJo?=
 =?utf-8?B?UEszL1JrTkMrUFo1SWdBaCtEaklYSDh6SVNLODUvbnhGN2ZhQ011cExvbjNG?=
 =?utf-8?Q?B169Qo6awFRrl7NKwK2nPZFdAOXGjSHd61N0zx6?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3ebcb00-4987-4762-400d-08d9671345c5
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5587.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 15:24:32.4159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1zR4daAO9DB/4XrzurRQDYzN2RrJQj6rfR33g987cW987N0yTwzfLPHeorq9peTknQaI8G+EhR+W2x5L5KKVUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5218
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.08.2021 12:28, Juergen Gross wrote:
> In order to avoid a malicious backend being able to influence the local
> processing of a request build the request locally first and then copy
> it to the ring page. Any reading from the request influencing the
> processing in the frontend needs to be done on the local instance.
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>

