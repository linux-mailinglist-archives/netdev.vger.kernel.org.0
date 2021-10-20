Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C8B43501D
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 18:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbhJTQ2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 12:28:16 -0400
Received: from mail-bn8nam12on2042.outbound.protection.outlook.com ([40.107.237.42]:54229
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230407AbhJTQ2P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 12:28:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I6OIOtPpA0pppJqxA+eNGd8Xw0OVudQlszOQH4Dp4C89YAbhyQcGpnAwEva/uakU1hGiI9yrWvBiy3FQMB3XXskgWTjBNg46mT/Frt6jJSW1GCpQ8+G9CuTSYnJeLOkTvdyIv14So6/shaWg/GOmE2okeaUWN4adSppGcS8diXHhUbmQnHzh35tEH0yKvHg/NQIHmJsohUOGyoZz3DdftZk/CsARc4zMT8J/un63pYIUwrAVEkJrmI/dvNUpzpOWVCYfyC+ABkF4u30eY3Kh5owORlIVInfyJAsDX9JHRejTEVqdXD9UZzjkxpMqbLm9UpR2kK5Sgbem10nzDIhiYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2rpHeWrXj1ESnDLy17GHVmUovfyMWZpYfpxZfApqOSs=;
 b=G1FM+XkRB3hIWGsy7IsyIg7rPln5185tMLCIIUGBgH1nV9g000bLlTxwGVW0cVKfL+wG8vmaxMGnNtabmRzYBfQ+yg5FEZpZZ5bHu9SNJD/kojA2wWomG1x7h26bVZVLrR54A6GiX1HV9q0wo2Pwp0D2nGclHrRAptLXKg7p5+w9VKyPBn64CeHKZD4BhIvAftMBaoMKUKZVsvoq7jEcYP09mRrBIsAFndHo50M163z6LGx+0mOFiIXQ5mhVSCClGGSyS5pEWdGcQHXKarLJAKskFw7Qhj0hu7xAO6CDvYNl8BOvMUESDXix4vS1fyKRmaeF1Yp03GJjYES2bntUxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2rpHeWrXj1ESnDLy17GHVmUovfyMWZpYfpxZfApqOSs=;
 b=NcC+5MIXp0HeTHCO+89xWvQOk3MllLlUy0YFLCiHu47tQrACT4MKu9OxE3+u2m5Y6ECcl4BKr0vFY0cXjNoCwyfC5hYpWC0/Na9NpTkMQll9k1sLYh6HqIR0KIE2NlNjArBT5lJanH896eqpjFnuo5wwZDIDj0eWtt/4SoIKh8HljuBker0hmci4bg1e56CeQGYhUhxBDu+B3YQVWB0uCDLh+azU0grmcqw5knhd3S9jqHACShvTU2bX6Mfcut5r6RdFjx7AIt80jIuoWdkunEdfLIBCfPaRVamdhmUXfZ93OjkoN8gIs/HDEm0W+ptUnIWtILZ80jHXMKPBue2VXw==
Authentication-Results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5175.namprd12.prod.outlook.com (2603:10b6:208:318::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Wed, 20 Oct
 2021 16:25:58 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.016; Wed, 20 Oct 2021
 16:25:58 +0000
Date:   Wed, 20 Oct 2021 13:25:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211020162557.GF2744544@nvidia.com>
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-13-yishaih@nvidia.com>
 <20211019124352.74c3b6ba.alex.williamson@redhat.com>
 <d5ba3528-22db-e06b-80bb-0db40a71e67a@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5ba3528-22db-e06b-80bb-0db40a71e67a@nvidia.com>
X-ClientProxiedBy: BLAPR03CA0109.namprd03.prod.outlook.com
 (2603:10b6:208:32a::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0109.namprd03.prod.outlook.com (2603:10b6:208:32a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Wed, 20 Oct 2021 16:25:58 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mdEPd-00HZJk-7y; Wed, 20 Oct 2021 13:25:57 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea9c8bac-58e2-448d-55ca-08d993e64c45
X-MS-TrafficTypeDiagnostic: BL1PR12MB5175:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5175DBB04DB56A5590632DE6C2BE9@BL1PR12MB5175.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jgwDhJvkWNQduZaCuVvaGMP1pSNso6Th0xw/HpdHE2TJ5+R8LP9lxWQhCbLJlAXJgPTtfDyLd/5AXWItodRjoToN409/WYiW2eM0Px0htD8g2fQz7yrueAD/WtPtJSHd5j4mwEZbVoB3augzebiEZi3vwaOpC8lT4uUvaP5fvniOfPYIyQSDN9QDh0oszrM40wjtExw5SWAG4KXhAI8AgiHVWMYfJQwQep/IFrTOIv3JNTfhybawxTJUkHKoanNJ4JSumyXK3xy5BVIAsW9b0efpfTheXsPeCCpkuAqKyym4ABdCFxQ5Bjz4U7hnGqT00gqKjZM51yYzhIqllzFy3AFvxhG2lUugx9mS9/2GBU9LAAQ6o9x+MTeFORz+VBnv5RTBv4qV1HLY9ArzbybdWbnISbEwBKYMs6TGdeLldJWoSnV5Xc12SQJitXGSsJZLOcJnZg701ZR1jod4AOuV7hOsiEe9omrOCRBruFnZtwLFn9IZeUB30QCJa0LbHEdkUz3cQ7UUNZb3DkLoykakMoUnQT14WeBBvjPXNhpfOTPcylyl8fVkdg1Zf2vHdI5JYWmm4wRt+D9imE2CfddpxZldd3cKpDsoromn49FJyT+qJyCR1ih1CSutSpCNf89Kay+rlqEOJnsaq+0MQ5jkaA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9746002)(26005)(9786002)(6862004)(37006003)(5660300002)(8676002)(38100700002)(508600001)(86362001)(66556008)(66476007)(316002)(8936002)(4326008)(66946007)(2906002)(36756003)(33656002)(1076003)(6636002)(107886003)(426003)(83380400001)(53546011)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?H+KX/IzgHYrsfySV/2/X5TD6UDcnbtrQL14nQWmvPFRBiVoWzcyvpr6mT3kI?=
 =?us-ascii?Q?IvRpyPPVSuuB49IV/+odKbfvX7loqY7Qi2zxnvtnebllkSLEwiR9hNd/i2+B?=
 =?us-ascii?Q?GBFUfrwHRJ1e3t/U7aR4ZEiLj/sPjsub7HWAFn+agowRreRO7FfiwhWXtyaA?=
 =?us-ascii?Q?9dW0PZTvML91BzFLduQZlLSGmrO+r2dd7EDSjIeod/5o9a8IRpVIdgylo1Pa?=
 =?us-ascii?Q?rKwRfmt5OEmDryzigVwOJB8CAbMbnBC6rtfpGUsu1u+zgcNhi4xo0AfDMtxJ?=
 =?us-ascii?Q?OJWEoVxaPtgdHABg/Uy18LBlKW8h7HGVA+/TRazgd7aT/go5nFqxReI8sEAw?=
 =?us-ascii?Q?JpRX3+kNUxDeD9uafMI0bWVnlwSzYkttGa/b5l2eQb7eSHyinwI8wOqi4S/A?=
 =?us-ascii?Q?EwOvK/gHWoAUsYZw8esLK7mNr+RP6uydFG0UIU+ltJLsp7jCQ1UpR3ZAZMRQ?=
 =?us-ascii?Q?yqpvg7TzSMxtN4BOdPGxOz9Q0qacGEIaNiMpZ+ionKGyJZ2wiplFVGcMR/xT?=
 =?us-ascii?Q?Rw4VJ5dEfzdgyyqNDFO881qRPAdG/PAj4OMn3CzMRVuaXAZycJg4g3WWX9R+?=
 =?us-ascii?Q?4rRF+YBidlx9PGFcFLSqLJbVrykHs+rH6Tgtxgda3zkyli/hFbs+xVD6Dqah?=
 =?us-ascii?Q?y6TWOXDIS9Dr0SeU6wI/sgBWPNKkwjW8spjf2clr0111mDt/e6AN71ENPNzt?=
 =?us-ascii?Q?CYMY8uMmp8y3qNdd1wmljrrVw1jqp4rJVJqloUViPKlvMpZSmPXoamN+iDZK?=
 =?us-ascii?Q?vKVj6Ed0dH+Ufd7wA6+ASFsnONz2Co1mTBk+vw/cLjvSaT/1aqR3vm9PWe52?=
 =?us-ascii?Q?Lo9zbaZgnJH8fubySRsdMyhzvLdoiyVWmd6R8HEhQBdVV/MMm3BV5+miJQkd?=
 =?us-ascii?Q?vsQNXxZLq+c0y9lx3x5eiFJp0/cJv/tEwsZuW0oCKPJjVJ21S1BTTMPRizRl?=
 =?us-ascii?Q?eEaZ0qVMMhdMWEF1pvhIMhn50GYT2Uk9FX83Y+Kwh8vqOzj15m7fmHSTssR6?=
 =?us-ascii?Q?xuRsTtMWyMJcl9WxoDQG/RmAB3U0p4ddaAKp97zzYhGz+xjikdfLI+FzfD9l?=
 =?us-ascii?Q?UcySoLUh/M1I97mshJJrBQApoBoq0IAAnvC35J0ROb0glfzwl7XqviGzO0o4?=
 =?us-ascii?Q?YO5JzC4NNOG5TRXYwjyhyZHHrNwsweetQn6CGacaoIpbtxWiBje3VVVHxSBV?=
 =?us-ascii?Q?HBLsmn33QvwvtT+3qivWOUZXHs0mTT+ZiLaBV+mzQwPx084csEe/7df0R0aM?=
 =?us-ascii?Q?C0vKqbnfCLDMmrZItcTcYPvzggj8foykvW0zBKKbug+N0SKdPnfvviXac6zF?=
 =?us-ascii?Q?hoX63cZOZsP7V3+t0xm1P2sSq/uPdq5BNrWrNIH5aDe0hL/sj85X4/AU8eBk?=
 =?us-ascii?Q?w0FLzcvxnQomDTdQqKOH5aTp0h+uBPafEXb7WslI8cQXDxJFUHve4A8vR41F?=
 =?us-ascii?Q?eZDiv/nJRgg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea9c8bac-58e2-448d-55ca-08d993e64c45
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2021 16:25:58.2721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgg@nvidia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5175
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 11:01:01AM +0300, Yishai Hadas wrote:
> On 10/19/2021 9:43 PM, Alex Williamson wrote:
> > 
> > > +
> > > +	/* Resuming switches off */
> > > +	if (((old_state ^ state) & VFIO_DEVICE_STATE_RESUMING) &&
> > > +	    (old_state & VFIO_DEVICE_STATE_RESUMING)) {
> > > +		/* deserialize state into the device */
> > > +		ret = mlx5vf_load_state(mvdev);
> > > +		if (ret) {
> > > +			vmig->vfio_dev_state = VFIO_DEVICE_STATE_ERROR;
> > > +			return ret;
> > > +		}
> > > +	}
> > > +
> > > +	/* Resuming switches on */
> > > +	if (((old_state ^ state) & VFIO_DEVICE_STATE_RESUMING) &&
> > > +	    (state & VFIO_DEVICE_STATE_RESUMING)) {
> > > +		mlx5vf_reset_mig_state(mvdev);
> > > +		ret = mlx5vf_pci_new_write_window(mvdev);
> > > +		if (ret)
> > > +			return ret;
> > > +	}
> > A couple nits here...
> > 
> > Perhaps:
> > 
> > 	if ((old_state ^ state) & VFIO_DEVICE_STATE_RESUMING)) {
> > 		/* Resuming bit cleared */
> > 		if (old_state & VFIO_DEVICE_STATE_RESUMING) {
> > 			...
> > 		} else { /* Resuming bit set */
> > 			...
> > 		}
> > 	}
> 
> I tried to avoid nested 'if's as of some previous notes.

The layout of the if blocks must follow a logical progression of
the actions toward the chip:

 start precopy tracking
 quiesce
 freeze
 stop precopy tracking
 save state to buffer
 clear state buffer
 load state from buffer
 unfreeze
 unquiesce

The order of the if blocks sets the precendence of the requested
actions, because the bit-field view means userspace can request
multiple actions concurrently.

When adding the precopy actions into the above list we can see that
the current patches ordering is backwards, save/load should be
swapped.

Idiomatically each action needs a single edge triggred predicate
listed in the right order.

The predicates we define here will become the true ABI for qemu to
follow to operate the HW

Also, the ordering of the predicates influences what usable state
transitions exist.

So, it is really important to get this right.

> I run QEMU with 'x-pre-copy-dirty-page-tracking=off' as current driver
> doesn't support dirty-pages.
> 
> As so, it seems that this flow wasn't triggered by QEMU in my save/load
> test.
> 
> > It seems like there also needs to be a clause in the case where
> > _RUNNING switches off to test if _SAVING is already set and has not
> > toggled.
> > 
> 
> This can be achieved by adding the below to current code, this assumes that
> we are fine with nested 'if's coding.

Like this:

if ((flipped_bits & (RUNNING | SAVING)) &&
     ((old_state & (RUNNING | SAVING)) == (RUNNING|SAVING))
    /* enter pre-copy state */

if ((flipped_bits & (RUNNING | SAVING)) &&
     ((old_state & (RUNNING | SAVING)) != (RUNNING|SAVING))
    /* exit pre-copy state */

if ((flipped_bits & (RUNNING | SAVING)) &&
     ((old_state & (RUNNING | SAVING)) == SAVING))
    mlx5vf_pci_save_device_data()

Jason
