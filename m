Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B024B231D3F
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 13:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbgG2LNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 07:13:15 -0400
Received: from mail-db8eur05on2075.outbound.protection.outlook.com ([40.107.20.75]:15649
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726365AbgG2LNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 07:13:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFBHRXOA0uxei34cwVPtQiIVbQ2fTJyZGWnJ73t5Z8SWJdr5P7M9wjfGRe7lsDQ4ZQaMj2dWRq/fM/Yzp0DWQsdhQcMF83LgxYrkuvF/jmU+1fF7xS86WbYWlISam62Z/thi4RPj+PWelj3ZaaJKzJJe6UtcUn+lpv1PHB4avaCTfoVZ4MULyC4URTpVRqqYThmsELJYAgFlmftQFqG6zIN4qq55Qsoi8ZwUbzyPOeke/JKKv4O5otBoEbJCt46REWt2sw1ypoZpG6J4Kd1rH9oj0GNZfyFu5969jQH+YCqcMc5Nywi++hsipU/2vS5YYLnDGZyIEmD8/kezQy1cjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPe8Pr/80s9y+H9ROcV9Mw6a14xWAL8L7gKG/Fx5ino=;
 b=fo8nte0tLuS5NQhi5oKN0bVD9bbNOj2RVPu3pqMOBq165rLKIdn/hmNnYWRW51nL7JeQQjrmzgxMQDvYeCSHDJuVeTc6pbjTakJa/BwRSlA+gwwjfSpj2RMZKUIOjlB3T2UwNQOrCDIlf3uogARgoepUtJN9WLSYRzRnCF4PG2D8kNtOXDlfF+aYIiZe2de12OiPucxTMmiAkP7IT4TuXi7uz9OEPkUoFAw4IrtM0KhqqfBvCRaJwOIGYLr6sFxo1BfKsKK62BQE7KVqHebX32QBvQbz+O0wmAsHBhf916pS9BJJTLeeellLGm1MJG0zz4KY0BYyivmPoPSThP1n5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NPe8Pr/80s9y+H9ROcV9Mw6a14xWAL8L7gKG/Fx5ino=;
 b=c/MGwn7D7mR4uny1ylO1Mf6PBbHgPE7URvlB8s+t8UIMmx7w0mgdYOOkaM+J8IWMT7VMsfHucjwmEccfvVxF7livLK4HkpTWSc02cuFvuZMmAgPeSszg4hFy1pl1JtBolDeS8fve45LThRYoBsXcAQktYk86I8jCebN6GvmDDCI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com (2603:10a6:208:b3::15)
 by AM0PR05MB6627.eurprd05.prod.outlook.com (2603:10a6:20b:145::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21; Wed, 29 Jul
 2020 11:13:09 +0000
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::9186:8b7:3cf7:7813]) by AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::9186:8b7:3cf7:7813%7]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 11:13:09 +0000
Date:   Wed, 29 Jul 2020 14:13:06 +0300
From:   Eli Cohen <eli@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>, alex.williamson@redhat.com,
        mst@redhat.com, pbonzini@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, shahafs@mellanox.com, parav@mellanox.com
Subject: Re: [PATCH V4 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
Message-ID: <20200729111306.GE35280@mtl-vdi-166.wap.labs.mlnx>
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
X-ClientProxiedBy: AM0PR06CA0126.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::31) To AM0PR05MB4786.eurprd05.prod.outlook.com
 (2603:10a6:208:b3::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mtl-vdi-166.wap.labs.mlnx (94.188.199.18) by AM0PR06CA0126.eurprd06.prod.outlook.com (2603:10a6:208:ab::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Wed, 29 Jul 2020 11:13:08 +0000
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 204256e8-003d-4d32-b637-08d833b06056
X-MS-TrafficTypeDiagnostic: AM0PR05MB6627:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB66270EB05AFB70301FBF5DF9C5700@AM0PR05MB6627.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o0olHCAaxIJSUssOIp6hb0vjXa82Z/CMfPHDWsVLXWHLtaKOUQ8FpcKqAvMcGkk5BuDR2UptmmJuBlnCRL4lhX/WvABPQYbZ1LXiRPa0b7XPpBCMHR6talWjK338XtAVd2EPpO+HJqEot3sHrM3V6y5JJUeJPSZL+YuJp34ensAcbrPOLoKSGrAM8jeUujF64Z88fVIqRfa2QdrddzGrxqdsQ+YlRJ9Pto+LYcDm9n926T3o7JzeiGOgxbDRKq5flCpHUlT9oRItfSImNBmKjBLX4t/knXCVOLbgpCnDPix/0zmMdoYwigxub+S4urNXXEVETbZhqImTjO06kQRCkw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4786.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(86362001)(52116002)(33656002)(8676002)(478600001)(107886003)(1076003)(956004)(6916009)(8936002)(6506007)(4326008)(9686003)(316002)(55016002)(7696005)(186003)(2906002)(16526019)(5660300002)(66476007)(26005)(83380400001)(66556008)(66946007)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: la7AhP2UR5G8jgMNlRs2SpxRuM6/xC374NCq/DiofuANVxIG8HBx12bToW+Ad4gxITFDc94YSG7paBv+OODk7SqcqzD4D3pXjXs+pv3KdzPk8cqHIHRd4GfO3yUtqM0/XiTMlG6fe6sUEwAqZSkuxZW4SOUjwo3N/AQvgXe/x2lyxWS05RPaCWfeIwKkLae0FGpGJEzXWQuDyWr5DKItCym9cZ4BIy0ckza/rKEX2vDoDlL7WfqfQk7b5/a2aptZz072qRGhnp2xnUJnTQPx0NQ8ziYXANxcrsa5AhXL8hyNL3UEmOGpEV+z0cXO0/w29WrAd8WDmhOULKGN+/bWoR/HugnDPton6Es0M/rWajcRVgnIxccOgsQRTeoEKbGqCLTyXMtdSBs8/9/JYWhLVfkvJks7Izrjnz4uiUPaTLjyFjjKftbHBCuYNlAvzFmsPXlxV1aqIP5mPQQXnlAw7KEiAcPO/Yjo7E1wU+PCYFQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 204256e8-003d-4d32-b637-08d833b06056
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4786.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 11:13:09.8010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sOnnG1pnAa3CrYtvc+aaV30Ox2yAwpy+/PIBn9agvIx19DgRGMPshThqAIBy5/wT4uli0ZtMoAzcd7atXAroLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6627
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 06:19:52PM +0800, Jason Wang wrote:
I am checking internally if we can work in a mode not requiring to
acknowledge the interrupt. I will update.

Thanks for the explanations.

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
