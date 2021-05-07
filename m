Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A91BB3766E4
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 16:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237524AbhEGOMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 10:12:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237527AbhEGOM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 10:12:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620396686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3xemaWuClFSKLtaEonBaCJQAvDoWvpQU/PJ5oe6FUAg=;
        b=T51nSFmtzdrKwEN5KUV2hqyNwyOLnwEprC20lZdEMd0LyjQ0i6vsrrSzvz9M7c4jd1rePf
        l+fcSBvA/7fZtE6RN3D9nyfi32e8YzSwiFwNf/bwo7WpQO8wyuno1hLwKH/b0MjGMB1FTP
        GqAGQ64PQ4BmfBatZzJK+vQrXaCckL8=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-189-BLRB7QLZNWS-djBMYF5Bww-1; Fri, 07 May 2021 10:11:24 -0400
X-MC-Unique: BLRB7QLZNWS-djBMYF5Bww-1
Received: by mail-ed1-f71.google.com with SMTP id i2-20020a0564020542b02903875c5e7a00so4505826edx.6
        for <netdev@vger.kernel.org>; Fri, 07 May 2021 07:11:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=3xemaWuClFSKLtaEonBaCJQAvDoWvpQU/PJ5oe6FUAg=;
        b=R7jGv5HUrjqZP5yCCc0xWS7mToT2NmGPQoSOiBtptfN/z4usKSXqmw7HqN8d1BKkxE
         ILbpKHgq3f9eY6NQN/XxZFWDa4MBx/+ZXBDSd/Tuj0W2gu3IZ98s3ckH3x6Ws5rp5Gbg
         i47l8xD4bG9nS34YxeZwYfNWXBZgab9eItT+DbHi3q43I/1bpD0Vk9RHzFJXRhGEiNeG
         UY8oB5jkWzECuj1MRwqEyRQt/m1dOTVQ/sO5Ns8S1qaoxy6fnysPctpRyoHfSiih1Xfy
         sT+fnPAstXFS9w/yVJgxLHYnnqwGnAnTO+4cqXhZkZnHgQG9xnDWL4OdFS/JBIt1SFAW
         QIlw==
X-Gm-Message-State: AOAM531N163k0hakLZQhwEW/y0z+m2lMu0/T2SF2nn31yUEKmNIMMlGe
        AP8pBlvvlrSMPEWN/IN9OlTC4ZT4vcVv/Sh3POUlfEs1gv67RmE/W5U5Ahqf0jf1MEkPmaV+ZOX
        QO3JtIYwMaUvbvXCS
X-Received: by 2002:a17:906:b0cd:: with SMTP id bk13mr10393836ejb.184.1620396683546;
        Fri, 07 May 2021 07:11:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyXr8UvxvxaXMzinyfRTZbCVHa8v6FhIvaqZukbWNaaGPDQqQTGT/mEtRf9SwSMNBw9IPtE+Q==
X-Received: by 2002:a17:906:b0cd:: with SMTP id bk13mr10393792ejb.184.1620396683250;
        Fri, 07 May 2021 07:11:23 -0700 (PDT)
Received: from steredhat (host-79-18-148-79.retail.telecomitalia.it. [79.18.148.79])
        by smtp.gmail.com with ESMTPSA id k5sm4910773edk.46.2021.05.07.07.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 07:11:22 -0700 (PDT)
Date:   Fri, 7 May 2021 16:11:20 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Joel Fernandes <joelaf@google.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [RFC][PATCH] vhost/vsock: Add vsock_list file to map cid with
 vhost tasks
Message-ID: <20210507141120.ot6xztl4h5zyav2c@steredhat>
References: <20210505163855.32dad8e7@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210505163855.32dad8e7@gandalf.local.home>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steven,

On Wed, May 05, 2021 at 04:38:55PM -0400, Steven Rostedt wrote:
>The new trace-cmd 3.0 (which is almost ready to be released) allows for
>tracing between host and guests with timestamp synchronization such that
>the events on the host and the guest can be interleaved in the proper order
>that they occur. KernelShark now has a plugin that visualizes this
>interaction.
>
>The implementation requires that the guest has a vsock CID assigned, and on
>the guest a "trace-cmd agent" is running, that will listen on a port for
>the CID. The on the host a "trace-cmd record -A guest@cid:port -e events"
>can be called and the host will connect to the guest agent through the
>cid/port pair and have the agent enable tracing on behalf of the host and
>send the trace data back down to it.
>
>The problem is that there is no sure fire way to find the CID for a guest.
>Currently, the user must know the cid, or we have a hack that looks for the
>qemu process and parses the --guest-cid parameter from it. But this is
>prone to error and does not work on other implementation (was told that
>crosvm does not use qemu).

For debug I think could be useful to link the vhost-vsock kthread to the=20
CID, but for the user point of view, maybe is better to query the VM=20
management layer, for example if you're using libvirt, you can easily do:

$ virsh dumpxml fedora34 | grep cid
     <cid auto=3D'yes' address=3D'3'/>

>
>As I can not find a way to discover CIDs assigned to guests via any kernel
>interface, I decided to create this one. Note, I'm not attached to it. If
>there's a better way to do this, I would love to have it. But since I'm not
>an expert in the networking layer nor virtio, I decided to stick to what I
>know and add a debugfs interface that simply lists all the registered=20
>CIDs
>and the worker task that they are associated with. The worker task at
>least has the PID of the task it represents.

I honestly don't know if it's the best interface, like I said maybe for=20
debugging it's fine, but if we want to expose it to the user in some=20
way, we could support devlink/netlink to provide information about the=20
vsock devices currently in use.

>
>Now I can find the cid / host process in charge of the guest pair:
>
>  # cat /sys/kernel/debug/vsock_list
>  3	vhost-1954:2002
>
>  # ps aux | grep 1954
>  qemu        1954  9.9 21.3 1629092 796148 ?      Sl   16:22   0:58  /usr=
/bin/qemu-kvm -name guest=3DFedora21,debug-threads=3Don -S -object secret,i=
d=3DmasterKey0,format=3Draw,file=3D/var/lib/libvirt/qemu/domain-1-Fedora21/=
master-key.aes -machine pc-1.2,accel=3Dkvm,usb=3Doff,dump-guest-core=3Doff =
-cpu qemu64 -m 1000 -overcommit mem-lock=3Doff -smp 2,sockets=3D2,cores=3D1=
,threads=3D1 -uuid 1eefeeb0-3ac7-07c1-926e-236908313b4c -no-user-config -no=
defaults -chardev socket,id=3Dcharmonitor,fd=3D32,server,nowait -mon charde=
v=3Dcharmonitor,id=3Dmonitor,mode=3Dcontrol -rtc base=3Dutc -no-shutdown -b=
oot strict=3Don -device piix3-usb-uhci,id=3Dusb,bus=3Dpci.0,addr=3D0x1.0x2 =
-device virtio-serial-pci,id=3Dvirtio-serial0,bus=3Dpci.0,addr=3D0x6 -block=
dev {"driver":"host_device","filename":"/dev/mapper/vg_bxtest-GuestFedora",=
"node-name":"libvirt-1-storage","auto-read-only":true,"discard":"unmap"} -b=
lockdev {"node-name":"libvirt-1-format","read-only":false,"driver":"raw","f=
ile":"libvirt-1-storage"} -device ide-hd,bus=3Dide.0,unit=3D0,drive=3Dlibvi=
rt-1-
> format,id=3Dide0-0-0,bootindex=3D1 -netdev tap,fd=3D34,id=3Dhostnet0 -dev=
ice rtl8139,netdev=3Dhostnet0,id=3Dnet0,mac=3D52:54:00:9f:e9:d5,bus=3Dpci.0=
,addr=3D0x3 -netdev tap,fd=3D35,id=3Dhostnet1 -device virtio-net-pci,netdev=
=3Dhostnet1,id=3Dnet1,mac=3D52:54:00:ec:dc:6e,bus=3Dpci.0,addr=3D0x5 -chard=
ev pty,id=3Dcharserial0 -device isa-serial,chardev=3Dcharserial0,id=3Dseria=
l0 -chardev pipe,id=3Dcharchannel0,path=3D/var/lib/trace-cmd/virt/Fedora21/=
trace-pipe-cpu0 -device virtserialport,bus=3Dvirtio-serial0.0,nr=3D1,charde=
v=3Dcharchannel0,id=3Dchannel0,name=3Dtrace-pipe-cpu0 -chardev pipe,id=3Dch=
archannel1,path=3D/var/lib/trace-cmd/virt/Fedora21/trace-pipe-cpu1 -device =
virtserialport,bus=3Dvirtio-serial0.0,nr=3D2,chardev=3Dcharchannel1,id=3Dch=
annel1,name=3Dtrace-pipe-cpu1 -vnc 127.0.0.1:0 -device cirrus-vga,id=3Dvide=
o0,bus=3Dpci.0,addr=3D0x2 -device virtio-balloon-pci,id=3Dballoon0,bus=3Dpc=
i.0,addr=3D0x4 -sandbox on,obsolete=3Ddeny,elevateprivileges=3Ddeny,spawn=
=3Ddeny,resourcecontrol=3Ddeny -device vhost-vsock-pci,id=3Dvsock0,guest-ci=
d=3D3,vhostfd=3D16,bus=3Dpci.0,addr=3D0x7 -msg
> timestamp=3Don
>  root        2000  0.0  0.0      0     0 ?        S    16:22   0:00 [kvm-=
pit/1954]
>  root        2002  0.0  0.0      0     0 ?        S    16:22   0:00 [vhos=
t-1954]
>
>
>This is just an example of what I'm looking for. Just a way to find what
>process is using what cid.
>
>Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
>---
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 5e78fb719602..4f03b25b23c1 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -15,6 +15,7 @@
> #include <linux/virtio_vsock.h>
> #include <linux/vhost.h>
> #include <linux/hashtable.h>
>+#include <linux/debugfs.h>
>
> #include <net/af_vsock.h>
> #include "vhost.h"
>@@ -900,6 +901,128 @@ static struct miscdevice vhost_vsock_misc =3D {
> 	.fops =3D &vhost_vsock_fops,
> };
>
>+static struct dentry *vsock_file;
>+
>+struct vsock_file_iter {
>+	struct hlist_node	*node;
>+	int			index;
>+};
>+
>+
>+static void *vsock_next(struct seq_file *m, void *v, loff_t *pos)
>+{
>+	struct vsock_file_iter *iter =3D v;
>+	struct vhost_vsock *vsock;
>+
>+	if (pos)
>+		(*pos)++;
>+
>+	if (iter->index >=3D (int)HASH_SIZE(vhost_vsock_hash))
>+		return NULL;
>+
>+	if (iter->node)
>+		iter->node =3D rcu_dereference_raw(hlist_next_rcu(iter->node));
>+
>+	for (;;) {
>+		if (iter->node) {
>+			vsock =3D hlist_entry_safe(rcu_dereference_raw(iter->node),
>+						 struct vhost_vsock, hash);
>+			if (vsock->guest_cid)
>+				break;
>+			iter->node =3D rcu_dereference_raw(hlist_next_rcu(iter->node));
>+			continue;
>+		}
>+		iter->index++;
>+		if (iter->index >=3D HASH_SIZE(vhost_vsock_hash))
>+			return NULL;
>+
>+		iter->node =3D rcu_dereference_raw(hlist_first_rcu(&vhost_vsock_hash[it=
er->index]));
>+	}
>+	return iter;
>+}
>+
>+static void *vsock_start(struct seq_file *m, loff_t *pos)
>+{
>+	struct vsock_file_iter *iter =3D m->private;
>+	loff_t l =3D 0;
>+	void *t;
>+
>+	rcu_read_lock();

Instead of keeping this rcu lock between vsock_start() and vsock_stop(),=20
maybe it's better to make a dump here of the bindings (pid/cid), save it=20
in an array, and iterate it in vsock_next().

>+
>+	iter->index =3D -1;
>+	iter->node =3D NULL;
>+	t =3D vsock_next(m, iter, NULL);
>+
>+	for (; iter->index < HASH_SIZE(vhost_vsock_hash) && l < *pos;
>+	     t =3D vsock_next(m, iter, &l))
>+		;

A while() maybe was more readable...

Thanks,
Stefano

