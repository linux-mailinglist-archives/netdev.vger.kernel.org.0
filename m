Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5431335CADA
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 18:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241769AbhDLQMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 12:12:53 -0400
Received: from mail-bn7nam10on2045.outbound.protection.outlook.com ([40.107.92.45]:47649
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241551AbhDLQMv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 12:12:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXuZ4ziFqj0ELHJ/c5iOrIdbXdwx8IP7+cK6H9e69upEM4sDBrhdBvdJMBuLZrr1HeEB+X46/5B0NT9JrPxdoin3lUXEzR3HUjldvm1/PcUYiZZiSVC3wiAHF3K6t4uq26l/JG9p8dLjZx3ZNjcl6rtfIvo6hMqVVeaoH582wraDm8HJbSWsGggbtlawrCGtQay903i0Z91m9QyUrYFcxeWNNsPthtVkaTNk1imui8Z2rw1Ei7o6H3EFNogqqprAeSSQEqwzh3iSnk8284vQ7z06O4zLYyPAPlvaUVz3qskFqaGUe9XnUCtIJRj/d5HzaEQriZPt/+PxSMtHQzQwMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hnjhhp2oAAnb8lmrVViDhY1/cpCdJUiEkT2L+XjPDiU=;
 b=IJAQX21/c2H2XYsQfGIUo01a/s/0K+ftJQ6VcqyVTOwhwJAJAKjltU9ivpOqswDRiJCw0Ykz2XGztCezA3HzMBsEiJaGTqDJ5C1fjMXy4GGqWj58yfo1vEKcz5DT3mDNIUGG3Xs0JyQrYf4/7svQBKyJCXACYkubI/LFXJAdJORjOyAdOy6EH7j2CYZsgV16BJQkUnX6iesxmvdXG9pzQ8x1xT8yCAucoMi/SRu2AkxF/TPkPYeZfsW8lifF3e2QnowM5E8cz6kftSSS4BBqRT+IpY9RvstotFESX0NjDRGPfxBXAVoRL45358Z2HgkNqQ/mKruCWNZ0Df8QVfd5kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hnjhhp2oAAnb8lmrVViDhY1/cpCdJUiEkT2L+XjPDiU=;
 b=QneShM9bL82EAqXnJjEtpcF5yHOS7b31P0YpizHamP6B8ni1ic7xGeBFvcezYHJWVS0J5VpoVyOR/OKP8T/ChyMU2rxHxWaPVeTsPUrRboYu1ff/a9FVsKuaht749rArPk5WF85241/VgwwQxZt+0N50oJkObfPtm8kO9uSGma8Zc/bfj8KsQnX/NIy6kd185ZeB0Ql4o6KUAofJcoQkkQkLvMbEpkBX8b9IiztlMZc+vi8Zfaq6JolLyp8R+Al3F92rQKgDuUbzaXZHZS9O1yEzEmJ64REp+JRhGztJWvwz+1kdgmbNT/05sPhLbF3hrQE2nc24dZnrbKznHf0Upw==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB2940.namprd12.prod.outlook.com (2603:10b6:5:15f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Mon, 12 Apr
 2021 16:12:31 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 16:12:31 +0000
Date:   Mon, 12 Apr 2021 13:12:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc:     "dledford@redhat.com" <dledford@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Hefty, Sean" <sean.hefty@intel.com>
Subject: Re: [PATCH v4 resend 01/23] iidc: Introduce iidc.h
Message-ID: <20210412161229.GA1115687@nvidia.com>
References: <20210407001502.1890-1-shiraz.saleem@intel.com>
 <20210407001502.1890-2-shiraz.saleem@intel.com>
 <20210407180529.GA547588@nvidia.com>
 <2ee289f620154810921df2bc2c903192@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ee289f620154810921df2bc2c903192@intel.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR02CA0137.namprd02.prod.outlook.com
 (2603:10b6:208:35::42) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0137.namprd02.prod.outlook.com (2603:10b6:208:35::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Mon, 12 Apr 2021 16:12:31 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lVzAr-004hAz-RQ; Mon, 12 Apr 2021 13:12:29 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12062fcf-855f-47c6-c2f7-08d8fdcdc665
X-MS-TrafficTypeDiagnostic: DM6PR12MB2940:
X-Microsoft-Antispam-PRVS: <DM6PR12MB2940843CFCD9F88921D9221DC2709@DM6PR12MB2940.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6yFPJ7xDlrq2/eBavN/TW9L4XlL+J3aH/X+vq3m/6Q+vZLkp/NFb0ReyNgMTG3AsKmrsZr17N5VevuWAHblzHkOH97wuuUXWmpRmfz8DMLwq7UoGXWYMAvRg2aWfwEI1yxsF4keju4u3c/ErqTBgnzOuVwefUTreRgiGmmQU8N4vRIyfqPcnG9360bK7FZZw3aWKtsLonA0ytqYjhp3kBxRwgpxG6eZL5PjA2dNR0MQyYlG4r/woga9HbgLqUiNBmZQpUecqDBQPye8gHZoRdqZyw8genpOaXeiIHE7M5D5AbLf6xL/JHw2U+erVHLxb8OPMWus5KY4xsUvNnrJ1DHfhjVckkl+vWiucFIzYqSPs7qEfYc9kWSv/Ht86T+2zj0cFIlUkAr7p52jkWB3640Sbdq+ozKDYtNB2CD6qOzEw3hVcs25enOJohSiIZ6twjBINoXnz1jp/I+Jimo9pxvZzRQy+BSE1WQqLXt5mmSX2oA0HKH1Xh1lBDpuWLKBvV0Z0lr4axu8+jnkV8o2GiGvjXbQeXTFwSrDvX5gJLFLcoNI9GXDEoWkeRCWV5KELwvYS2LeBr94MDorl+5BsZuhL8m9r/y1O8uwm/DxXMFI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(366004)(396003)(346002)(39860400002)(9746002)(38100700002)(7416002)(478600001)(66946007)(9786002)(8936002)(5660300002)(2906002)(4326008)(8676002)(83380400001)(54906003)(186003)(66476007)(1076003)(6916009)(33656002)(316002)(36756003)(66556008)(426003)(2616005)(86362001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?U8OAiptXZHte7LNBCr/dsVk6Monrj5X6I8wfEE//s9b7RsRrMPLxNsqOgzuU?=
 =?us-ascii?Q?RoxBB29crgkfPH3wVCoARED/0olfAuAan/mPsWHs+1efM+fRlaMu3Q8cSDJC?=
 =?us-ascii?Q?S+/V1wQVwIGcy9p9EBuQGZN+b9g0TaugDJZ79Z5nb1vufVHqOLSlxDomNlD/?=
 =?us-ascii?Q?+rNry4CihPFivicrkgP4izf6DKSNcQ6hT0PNXJHt9Fs30YfgpLYEdkoG0iuB?=
 =?us-ascii?Q?6kPFs3W6HuMtnq103LDU8kfJJ3D78CkdOwzaAzmmCL4wg2fo19etCzuaZ3+i?=
 =?us-ascii?Q?eKULt7xgs7A/dXXlaz4BaUxtcOkqgVpE3CHOurybA6R0jkEHBQ8+doQYoW/Q?=
 =?us-ascii?Q?uFTU69zElzO/rxvB7DFhUUL5NI/Dn9PnrRWOsELdoZTT+RFCkHsf7SU/Qm0s?=
 =?us-ascii?Q?CxAnVdXFS8vbDk4wAOEttHHsyfMwdNGFQVIee20Cr2TKMZzVwa0rOoAl+Tvv?=
 =?us-ascii?Q?UNxlLkFSAYdIEqyZ9fNMgRHGgWU8SywTbxQdq+56DbfG6BInprfYcKMWxUig?=
 =?us-ascii?Q?zbLcalUBKXDSpPrer6c8W1Ly+tK5WSRK/ZwqOSfBXgDU6y2iXEIxRv2XPJ4C?=
 =?us-ascii?Q?KqvJJCfza4WcO2UGT+sxiRklzPllMm0Nkz9X+Mye4sHZkGAukJKnyn1KBmNe?=
 =?us-ascii?Q?m6SnmR2TfJTk6g693t/ZgNVXEedUWV64tyi2stVZ8PyeEA6JdTuIHIjvfcvm?=
 =?us-ascii?Q?6gmF9W/xlwG+Bofg9NJcO2d0/iRTksQ8tQ7iVfAb7ItctPqtDgdDDRQz0VYI?=
 =?us-ascii?Q?tpwJnwkjPn/LerU+IgIa+rjb4Xy29lV7WjkXlvqPGZZggEtdgxh9wVs2OzEW?=
 =?us-ascii?Q?XlVvu3yKPNWGfqdCQtIEDcRPihStYBjf61KDx5TzcHWGcBmKnMuh0AhrvQ0a?=
 =?us-ascii?Q?hPJ9JNYXzwOCgUGwLd9Mbyhckl7543s8ErnAMfmNRA8Y5jIGE+cOXZ3mIiqR?=
 =?us-ascii?Q?uxViUgWvaGf1aLfGb9kyte4KTX67uNOn97z8CH3lKasz/L+Phf57kebiIayE?=
 =?us-ascii?Q?XTuc/HyK0FVFG1N2p2u3oliiktQppl5eXcBlmQjLDK/jxQt+tZpeBplQVTlJ?=
 =?us-ascii?Q?KOok5V6DE3zJGU41Qnk7UOwXrgaLtMRjT4gJuQ+1Z+FLDOWLJ07GbU4sJAda?=
 =?us-ascii?Q?yStJDq/ED1yO0J05RJ8wFRW3wupKgwjCrEnlM+AZkdzXfjY4FPjKwZphrEyq?=
 =?us-ascii?Q?BcudLKx/V/IYNDYfoHgaaZL969zXkEw28A2LRqTFf2l340YWLSDhl2vFqhVD?=
 =?us-ascii?Q?pP+ompPMj/3FyfuvNYJWEo0JBmlZqlfA6h45WtNLSRZDcZOY1yVVmLo6L8vl?=
 =?us-ascii?Q?p3c6VrQRqnGgiC4C6MIrcXgnp9Ygk8VKYjslYKziqv2U6A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12062fcf-855f-47c6-c2f7-08d8fdcdc665
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 16:12:31.2905
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XSoIlN5zdGmLEeXK90p/LLfCBbqvpj3Lr6ui8vlWdfu3UXbXtpD4JHNTDDGJ1R2B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB2940
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 02:51:18PM +0000, Saleem, Shiraz wrote:

> > Where is ftype initialized?
> 
> Today it is just pf. But the upcoming Intel ethernet VF driver will
> set it to true.

Then it is dead code, don't send dead code to the kernel.

> > This cdev_info should just be a 'struct ice_pf *' and the "struct
> > iidc_core_dev_info" should be deleted entirely. You'll notice this
> > ends up looking nearly exactly like mlx5 does after this.
> 
> It was intentionally designed to be core device object carving out
> only pieces of the PF information required by the rdma driver. The
> next near-term PCI driver using IIDC can also this. Why expose the
> whole PF? This is a design choice no? Why do we need to follow mlx5?

When you get around to building your multi-driver API it should be
structured so it doesn't have a de-normalization of the data - don't
copy from one authoritative struct to some other struct just to get
some weird information hiding.

The PF driver should be a subclass if your "generic" driver and
directly embed some struct like this as the singular canonical source
of information, not be duplicated.

> I don't follow what the hackery is. Just because we use cdev_info in
> the .ops callbacks as opposed to ice_pf?

There are too many signs to ignore:
 - The obfuscated extensible structs being passed into ops that are
   only encoding a couple function call parameters
 - The ops that only have one implementation
 - The struct that is a complete copy of a different, but "internal",
   struct

You do stuff like this to make stable ABIs. This is forbidden by Linus
for in-kernel APIs, and it is not the kernel style in general to code
like this.

Jason
