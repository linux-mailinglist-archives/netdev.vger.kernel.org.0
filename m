Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A17123202A
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 16:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgG2OQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 10:16:04 -0400
Received: from mail-eopbgr00081.outbound.protection.outlook.com ([40.107.0.81]:11150
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726353AbgG2OQE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 10:16:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cr6yi/GzUbC0WLdLNf0qWFyGPQTo1n0dZehn3bDET4jmuaZdFPomt6GoToS2kPFJJVtfjpQzqLM1BNK/322FViAANMKg10c7gi679KznfRMguUTpENlt98zmB696DF0WyUyzkBPaJ+JjzM9E1CvAsLbhfcLDUTwj8NAiZZgky/NlmvCwBNHeEp8UU/iKLSPw8e+yj+Z5fLbCeDQoC/qx7ov7v/TQt57mLH04K/O/U838TOfI0jfphtjhNcHtAkDr4xWAk+vaUpPMe+AG5ogr8QntC5lb3mS736/dqG3AeT0AHsYjuGEKtsFaPhkQ3a8pVObhExeh39lOhrbFQD/ZzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ck0NDWdsXtYCvPgFc36uc/xrpbNsJDDfFPv39weCoNM=;
 b=hoX5AHMHO50kZBACz1ZD3uFcZ5oN4cSZ1a8OryoeS8KfF2j0FLpntdlbbOgFVEuqHHweVCfkaNF77bHRjJFtdustlit4XwMBHJs178Qgq5E/LT/BjkNzxciNCDb8LHLfBENVdpjbn4dfCwINCkJqXHK6D0eAXD5Y59RuMMT2srxenGK8TSZqdqMsAxJInzrZLxFAuYJO7SVPKEyuBxQec+E9zTWjQ1QsRV2ln/Zxd7FnEX2HYOKQFhemYCydtziIC/JrKqNC/yxuisWq0UZTf/vGCLsXPdG6hKHZ7NlOYVwcwk63t1X6RKrFkQgXqijSvPSi/L+WunfnxE2riaN74w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ck0NDWdsXtYCvPgFc36uc/xrpbNsJDDfFPv39weCoNM=;
 b=SRl0+0wMFaoMNTdEKwoAIHZh5CBlg35vvm7zTZT+sOJ5H9t/d2M1l6mlK7T/YjYt+XkoruDY8eJK8OLtHre3qOUPMucAr8Dfi9o1+oNLrfWUbbJdlPb3P61mTfQbG1Cibg8WsqnfwjjNZv+d8GuAI8ShnbGa+Bg+ZQzfuAzi5fo=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com (2603:10a6:208:b3::15)
 by AM0PR0502MB3683.eurprd05.prod.outlook.com (2603:10a6:208:25::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17; Wed, 29 Jul
 2020 14:15:59 +0000
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::9186:8b7:3cf7:7813]) by AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::9186:8b7:3cf7:7813%7]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 14:15:59 +0000
Date:   Wed, 29 Jul 2020 17:15:54 +0300
From:   Eli Cohen <eli@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>, alex.williamson@redhat.com,
        mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, shahafs@mellanox.com, parav@mellanox.com
Subject: Re: [PATCH V4 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
Message-ID: <20200729141554.GA47212@mtl-vdi-166.wap.labs.mlnx>
References: <20200728042405.17579-1-lingshan.zhu@intel.com>
 <20200728042405.17579-5-lingshan.zhu@intel.com>
 <20200728090438.GA21875@nps-server-21.mtl.labs.mlnx>
 <c87d4a5a-3106-caf2-2bc1-764677218967@redhat.com>
 <20200729095503.GD35280@mtl-vdi-166.wap.labs.mlnx>
 <45b7e8aa-47a9-06f6-6b72-762d504adb00@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <45b7e8aa-47a9-06f6-6b72-762d504adb00@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: AM0PR10CA0124.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:e6::41) To AM0PR05MB4786.eurprd05.prod.outlook.com
 (2603:10a6:208:b3::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mtl-vdi-166.wap.labs.mlnx (94.188.199.18) by AM0PR10CA0124.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e6::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Wed, 29 Jul 2020 14:15:58 +0000
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fb26a485-b851-49e7-f80c-08d833c9eacc
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3683:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB3683F6AA629249B0852CD6A3C5700@AM0PR0502MB3683.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BuYHxfdtQfNuJTMlUQLbs1io61/nFqkrnRwkYICTX/ocygUUEpj8WYsjEq6sWe/N2Sm3iaKHBLtllPldwnhoCMRIFolGjvOUR2mlV3H9TQlCAp1PxmCjGRAfyM5sSCJEnf9UjMdPAfzOOdoddmJnKHSBAq9cCZFxsHnhvfugkbJLRggwLZt5RJcRoBz7WztTv3AqjvoWpiEZIMAgDsjDm4hBjlqDyS/xY9C79coHNKehfeRU8sf4K41D++aUBPLCiux2tx/Z6U9E9kynSEd8XcQ/qNx2kakcJwkIA2Jllu0CsHLJIc1rAMVQL9Le0L/1Zp/PaUd9064eM4o7pcSHLg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4786.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(39860400002)(136003)(396003)(346002)(8676002)(33656002)(8936002)(83380400001)(4326008)(6916009)(316002)(16526019)(66476007)(6666004)(86362001)(55016002)(5660300002)(66946007)(107886003)(66556008)(956004)(7696005)(52116002)(2906002)(478600001)(186003)(7416002)(6506007)(26005)(9686003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 4Yyaw9qp6aBOQJF9qsDBPGyXraewyB/+kVPzdTXjFxJo6u72J2Hw9QFnnGLknZ6Ez70vAZxvmhuB1V0gdKqv/DBOeqY6W6rkqZ/uYR8O9L7ae6n73OhrcE8S3urOM7LaUV+K8m26nZdJ0HshZRgzhlBrdGdvkHHdwDMp178yitFU/SorjKUKkUTkkbm3CeSEQS1ACG/3r8YnZDw9vmp6t0YeCA//ogi7CrXwc18CzGRz2uVQ46PQw2DwAM9gAfyKq6ORfhCeLRLvmf7jH3DMuQD7kNkUf9qpvqTXXiXpLLRjArNj/mCi+5FtUn0W7cmZpRZydA5uGEy3alFqasSKtNEUUIpUUxM0PNCIqoIHtYP3a+rFvdPP4TB3N577x3Bmb9ZC+IUVm3SAzhNR+jTmh0lrTzYP9i1mNA+Li/s4fOPcxnVynxuZGMwArSifMQSdWoBgvCJWY4GtVzU8LPKjxgiVrtFOBsm+ydkOidTIOpRuDPtR+tIo3pvzkSsMuz9i0wSZrkKAB5vCrOmDYNHjEZ/ebC6OA3lRKjVvXOwgiJ/LjMmQcuXlrW8NjVnUqKaQOLP0/3xt5hfeza00J30Nkm7IZPWMtyhTTA3Ppa0Pn2yO0TU+WIFF8FEOeXPcYGuE8uLmrI+Q4MY+akAX4qoF7Q==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb26a485-b851-49e7-f80c-08d833c9eacc
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4786.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 14:15:59.6408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H0IRJwGCZw6MKCsV1pcxgrxj5IyeM0kA7pIzbbeEN9vmoPwlRt3fSHRIwaorEgnm66DRGbqc2A3SIaJgVYBJ5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3683
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OK, we have a mode of operation that does not require driver
intervention to manipulate the event queues so I think we're ok with
this design.

On Wed, Jul 29, 2020 at 06:19:52PM +0800, Jason Wang wrote:
> 
> On 2020/7/29 下午5:55, Eli Cohen wrote:
> >On Wed, Jul 29, 2020 at 05:21:53PM +0800, Jason Wang wrote:
> >>On 2020/7/28 下午5:04, Eli Cohen wrote:
> >>>On Tue, Jul 28, 2020 at 12:24:03PM +0800, Zhu Lingshan wrote:
> >>>>+static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, int qid)
> >>>>+{
> >>>>+	struct vhost_virtqueue *vq = &v->vqs[qid];
> >>>>+	const struct vdpa_config_ops *ops = v->vdpa->config;
> >>>>+	struct vdpa_device *vdpa = v->vdpa;
> >>>>+	int ret, irq;
> >>>>+
> >>>>+	spin_lock(&vq->call_ctx.ctx_lock);
> >>>>+	irq = ops->get_vq_irq(vdpa, qid);
> >>>>+	if (!vq->call_ctx.ctx || irq == -EINVAL) {
> >>>>+		spin_unlock(&vq->call_ctx.ctx_lock);
> >>>>+		return;
> >>>>+	}
> >>>>+
> >>>If I understand correctly, this will cause these IRQs to be forwarded
> >>>directly to the VCPU, e.g. will be handled by the guest/qemu.
> >>
> >>Yes, if it can bypassed, the interrupt will be delivered to vCPU directly.
> >>
> >So, usually the network driver knows how to handle interrups for its
> >devices. I assume the virtio_net driver at the guest has some default
> >processing but what if the underlying hardware device (such as the case
> >of vdpa) needs to take some actions?
> 
> 
> Virtio splits the bus operations out of device operations. So did
> the driver.
> 
> The virtio-net driver depends on a transport driver to talk to the
> real device. Usually PCI is used as the transport for the device. In
> this case virtio-pci driver is in charge of dealing with irq
> allocation/free/configuration and it needs to co-operate with
> platform specific irqchip (virtualized by KVM) to finish the work
> like irq acknowledge etc.  E.g for x86, the irq offloading can only
> work when there's a hardware support of virtual irqchip (APICv) then
> all stuffs could be done without vmexits.
> 
> So no vendor specific part since the device and transport are all standard.
> 
> 
> >  Is there an option to do bounce the
> >interrupt back to the vendor specific driver in the host so it can take
> >these actions?
> 
> 
> Currently not, but even if we can do this, I'm afraid we will lose
> the performance advantage of irq bypassing.
> 
> 
> >
> >>>Does this mean that the host will not handle this interrupt? How does it
> >>>work in case on level triggered interrupts?
> >>
> >>There's no guarantee that the KVM arch code can make sure the irq
> >>bypass work for any type of irq. So if they the irq will still need
> >>to be handled by host first. This means we should keep the host
> >>interrupt handler as a slowpath (fallback).
> >>
> >>>In the case of ConnectX, I need to execute some code to acknowledge the
> >>>interrupt.
> >>
> >>This turns out to be hard for irq bypassing to work. Is it because
> >>the irq is shared or what kind of ack you need to do?
> >I have an EQ which is a queue for events comming from the hardware. This
> >EQ can created so it reports only completion events but I still need to
> >execute code that roughly tells the device that I saw these event
> >records and then arm it again so it can report more interrupts (e.g if
> >more packets are received or sent). This is device specific code.
> 
> 
> Any chance that the hardware can use MSI (which is not the case here)?
> 
> Thanks
> 
> 
> >>Thanks
> >>
> >>
> >>>Can you explain how this should be done?
> >>>
> 
