Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5B1231C59
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgG2JzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:55:12 -0400
Received: from mail-eopbgr40069.outbound.protection.outlook.com ([40.107.4.69]:46193
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726054AbgG2JzL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 05:55:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ReczpOuvxUS7h+tmBwoaf6orhL2dRyR3yv81yqGI3t6mbJ15AT8R0binxHhPYbDTGnx/lttfsYDK/42PePyVL9tO17IkwbxPk/Z5/hFBWrEQM+EMCtMV7UtbpbDjYoekcXa1yrC/8YK4vj/ZTIhMXaBcYPNwjl9vbeil5n7RSKvTghbDY2VcyMsWFmZmzKuQft10fjRnpzp+88IMpb1HWndlQvUUTUv5YRGiwHFEv88/cI0uZ6nOfeWwBV1ZZ+009G57nr7rzQz09F8XSTSMRAfgVSJY8wb3/2UBN+rWsV0NWLGrtY5dkBtRK7ZU7NWb9cB3p4x1wuUh00E1wN7utQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGpYvGtzhckEzz3B4eCMLc9PZyge4zMFfc1IaWWMCTE=;
 b=InC2ncQAYzY9l3h/Amrgcy9Q4JhXdKk29jpYfG6at452riMhrLHGFNUFZ/7j1vdRKa6b9XYzPrAHVOeN7eefp3h8+NsX20oVD/rbfakKTShcW6wtUIAPiWS5XFIYXRDEqtjFo5BDwFKrOBw2LgSlVmh1u9bkE02GpwWjuZVFXvSHRw64tNZ9ncv/ZC3JdjpAkEC0YujjEgzdbYjxbm/dMP8oEwcgCk7hvU+ijU5zx2gwlG3gT7Mkt5xw6DK1r/I4oEqsxjm/mXmdFnWPVmz33vUhLBvXi0rJXtt4/8P2xeAFhaLiBR+IyFMz0mBzGPA3q3GRDX1UvE934yQLys1j0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CGpYvGtzhckEzz3B4eCMLc9PZyge4zMFfc1IaWWMCTE=;
 b=CJc+MmKNN+dGdFedDYaGVMdBDajyGgY6y4d5pd8Q+Dj/Ue1L2SlR1sMQbYR7soBzTT6X02K4aegFfTnjR4Vm8ktlD1rBX+6lk7wFlpPQ1JjVZ8vVL6eQzyZvPwrPho9o7K9/eyDJJkRSD+20VFGazvo2l0yFNf6zxhlvkMS66wk=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com (2603:10a6:208:b3::15)
 by AM0PR0502MB4067.eurprd05.prod.outlook.com (2603:10a6:208:b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.27; Wed, 29 Jul
 2020 09:55:07 +0000
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::9186:8b7:3cf7:7813]) by AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::9186:8b7:3cf7:7813%7]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 09:55:07 +0000
Date:   Wed, 29 Jul 2020 12:55:03 +0300
From:   Eli Cohen <eli@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>, alex.williamson@redhat.com,
        mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, shahafs@mellanox.com, parav@mellanox.com
Subject: Re: [PATCH V4 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
Message-ID: <20200729095503.GD35280@mtl-vdi-166.wap.labs.mlnx>
References: <20200728042405.17579-1-lingshan.zhu@intel.com>
 <20200728042405.17579-5-lingshan.zhu@intel.com>
 <20200728090438.GA21875@nps-server-21.mtl.labs.mlnx>
 <c87d4a5a-3106-caf2-2bc1-764677218967@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c87d4a5a-3106-caf2-2bc1-764677218967@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: AM0P190CA0008.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::18) To AM0PR05MB4786.eurprd05.prod.outlook.com
 (2603:10a6:208:b3::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mtl-vdi-166.wap.labs.mlnx (94.188.199.18) by AM0P190CA0008.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Wed, 29 Jul 2020 09:55:06 +0000
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: aa5288a5-8a86-4a63-b361-08d833a5799f
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4067:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB40677B8080171C1108354B40C5700@AM0PR0502MB4067.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vFL925ZRHjon8VPgNEatXTUMyXjFH+8p9t2YTpc1a9WCfnb0rDoBk6fhMSUtp3xmp2J89OfI50ekqQACqzjEiHmM1QKP4YC7jkM2LzwTY5KaEjlEmxG9ofoQgLoo2aS0KkgBNi67c6+4Lyy7AvPee+F02CW2/MDQPUGoMRE2j+lRqa5DNEgmP38jHo3/i6Z2tlnED0eVNN0cGA/RGCZvk7pjoT3G716PKeyc0hPdZ6BRSzXbW2klUAj9cL/bsYI/1HcSgNxv7tMN0dt4d4HfOXSPdYtobAAZweXUWWZWgfXkBWtTq7OZE9vCZWYw57NRpHxR/CHF4q4znOUjaYClJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4786.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(366004)(136003)(396003)(39860400002)(4326008)(33656002)(8676002)(2906002)(52116002)(7696005)(26005)(186003)(6916009)(316002)(66946007)(7416002)(8936002)(66476007)(66556008)(16526019)(6506007)(86362001)(478600001)(5660300002)(55016002)(9686003)(956004)(6666004)(107886003)(1076003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vzVh8eTxi9PWUF9Gkt0Aa5rlKr2R2R3Eca5A6om9i2oJ1tjMzRC9S3Xy6Ob+JrU/5LoQV/1bA1E00oUVFulFtFEGTP6YUPruZWXslBFvO4sgMV+WL0MmTFxlsF6HkEFu3qkHxbDUUSrSqvYZ86d0vI+1EMy+dk1D1zgRKQXln7r0h4AYg5CNR2OwEOJ9Adnah9LM9gkEIW9id4zBDy7xx62WBXpDm0sBhYonSy0Syga4tnCsLg1SID4UB67i0bV35U1YyBziKmoKyQYxsOHnlaTmY4lZL1BR4rm1O6Uo7gN5Q1HSuYu7qG7YN/uSeWMh+hj9xdtBknm8A+6BY86ARxdsVAPJ0+7kK1Gmbj2V3GGy6rVuRJl7aZ0LOjMeCJsxKkcZ/lBgA7XQXxngcQ3zmIHO+fu4SRemEYTplQjyzsRCysWRTykj9/tFkK9Ko3r74LkfqjClE+MXhyoHPSO7sH+xszMOT05dflPT6rkms8E=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa5288a5-8a86-4a63-b361-08d833a5799f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4786.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 09:55:07.8283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e4i6+Iw45njVDqg15o/FYVE/NT66E7ziV1c4/BaIoDlNblZWdxvzCVWXxkI7bD2J7IuFJcqYV+UFcxZz6uc1YA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4067
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 05:21:53PM +0800, Jason Wang wrote:
> 
> On 2020/7/28 下午5:04, Eli Cohen wrote:
> >On Tue, Jul 28, 2020 at 12:24:03PM +0800, Zhu Lingshan wrote:
> >>+static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, int qid)
> >>+{
> >>+	struct vhost_virtqueue *vq = &v->vqs[qid];
> >>+	const struct vdpa_config_ops *ops = v->vdpa->config;
> >>+	struct vdpa_device *vdpa = v->vdpa;
> >>+	int ret, irq;
> >>+
> >>+	spin_lock(&vq->call_ctx.ctx_lock);
> >>+	irq = ops->get_vq_irq(vdpa, qid);
> >>+	if (!vq->call_ctx.ctx || irq == -EINVAL) {
> >>+		spin_unlock(&vq->call_ctx.ctx_lock);
> >>+		return;
> >>+	}
> >>+
> >If I understand correctly, this will cause these IRQs to be forwarded
> >directly to the VCPU, e.g. will be handled by the guest/qemu.
> 
> 
> Yes, if it can bypassed, the interrupt will be delivered to vCPU directly.
> 

So, usually the network driver knows how to handle interrups for its
devices. I assume the virtio_net driver at the guest has some default
processing but what if the underlying hardware device (such as the case
of vdpa) needs to take some actions? Is there an option to do bounce the
interrupt back to the vendor specific driver in the host so it can take
these actions?

> 
> >Does this mean that the host will not handle this interrupt? How does it
> >work in case on level triggered interrupts?
> 
> 
> There's no guarantee that the KVM arch code can make sure the irq
> bypass work for any type of irq. So if they the irq will still need
> to be handled by host first. This means we should keep the host
> interrupt handler as a slowpath (fallback).
> 
> >
> >In the case of ConnectX, I need to execute some code to acknowledge the
> >interrupt.
> 
> 
> This turns out to be hard for irq bypassing to work. Is it because
> the irq is shared or what kind of ack you need to do?

I have an EQ which is a queue for events comming from the hardware. This
EQ can created so it reports only completion events but I still need to
execute code that roughly tells the device that I saw these event
records and then arm it again so it can report more interrupts (e.g if
more packets are received or sent). This is device specific code.

> 
> Thanks
> 
> 
> >
> >Can you explain how this should be done?
> >
> 
