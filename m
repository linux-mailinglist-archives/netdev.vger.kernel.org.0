Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E84C22169A
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 22:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgGOUu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 16:50:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35636 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgGOUuz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 16:50:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FKWKj1066227;
        Wed, 15 Jul 2020 20:50:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JvYRaru1KyYvRqOyLFyBN0GUWD3NhbyrMdaoHytyByQ=;
 b=BtYr5FPVDBA0xZ3ZC5s7rA9zlu4IMZKwCOpKP8o4mKoCgEhKuDLX+jys8JSOT68qZ706
 e0aIdV9/NT5XqvrPwVWccCbGkewNxOMAdYI/TH7IY6/G7LEI5z3VsGkRmOpPtowp/s4Y
 y0BzoU7Sbhe1/BHk5LNpq/isGw/ELrGnOdPTb/QpfqpIIVwesbt6kZr7I8Ne1Ha8kw/l
 n1lp7ZG3rP9nSczU7NwVmYUB+bde3OmiHxgAqlyR778p8tTKC2+V9g5KEIs4qA+qVi42
 e5vbUn2XZWYPeOC+N1WZHY1brO5USwU8uSsr4nqBpxEz2HfZL9qJLCKw+Z+nV0vX5gCn gg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 3274urdt23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 15 Jul 2020 20:50:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06FKXeaD171549;
        Wed, 15 Jul 2020 20:50:14 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 327q0ryurw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jul 2020 20:50:14 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06FKo8kx002016;
        Wed, 15 Jul 2020 20:50:08 GMT
Received: from [10.39.217.130] (/10.39.217.130)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Jul 2020 13:50:08 -0700
Subject: Re: [PATCH v2 00/11] Fix PM hibernation in Xen guests
To:     Anchal Agarwal <anchalag@amazon.com>
Cc:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "jgross@suse.com" <jgross@suse.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
References: <cover.1593665947.git.anchalag@amazon.com>
 <324020A7-996F-4CF8-A2F4-46957CEA5F0C@amazon.com>
 <c6688a0c-7fec-97d2-3dcc-e160e97206e6@oracle.com>
 <20200715194933.GA17938@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Autocrypt: addr=boris.ostrovsky@oracle.com; keydata=
 xsFNBFH8CgsBEAC0KiOi9siOvlXatK2xX99e/J3OvApoYWjieVQ9232Eb7GzCWrItCzP8FUV
 PQg8rMsSd0OzIvvjbEAvaWLlbs8wa3MtVLysHY/DfqRK9Zvr/RgrsYC6ukOB7igy2PGqZd+M
 MDnSmVzik0sPvB6xPV7QyFsykEgpnHbvdZAUy/vyys8xgT0PVYR5hyvhyf6VIfGuvqIsvJw5
 C8+P71CHI+U/IhsKrLrsiYHpAhQkw+Zvyeml6XSi5w4LXDbF+3oholKYCkPwxmGdK8MUIdkM
 d7iYdKqiP4W6FKQou/lC3jvOceGupEoDV9botSWEIIlKdtm6C4GfL45RD8V4B9iy24JHPlom
 woVWc0xBZboQguhauQqrBFooHO3roEeM1pxXjLUbDtH4t3SAI3gt4dpSyT3EvzhyNQVVIxj2
 FXnIChrYxR6S0ijSqUKO0cAduenhBrpYbz9qFcB/GyxD+ZWY7OgQKHUZMWapx5bHGQ8bUZz2
 SfjZwK+GETGhfkvNMf6zXbZkDq4kKB/ywaKvVPodS1Poa44+B9sxbUp1jMfFtlOJ3AYB0WDS
 Op3d7F2ry20CIf1Ifh0nIxkQPkTX7aX5rI92oZeu5u038dHUu/dO2EcuCjl1eDMGm5PLHDSP
 0QUw5xzk1Y8MG1JQ56PtqReO33inBXG63yTIikJmUXFTw6lLJwARAQABzTNCb3JpcyBPc3Ry
 b3Zza3kgKFdvcmspIDxib3Jpcy5vc3Ryb3Zza3lAb3JhY2xlLmNvbT7CwXgEEwECACIFAlH8
 CgsCGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEIredpCGysGyasEP/j5xApopUf4g
 9Fl3UxZuBx+oduuw3JHqgbGZ2siA3EA4bKwtKq8eT7ekpApn4c0HA8TWTDtgZtLSV5IdH+9z
 JimBDrhLkDI3Zsx2CafL4pMJvpUavhc5mEU8myp4dWCuIylHiWG65agvUeFZYK4P33fGqoaS
 VGx3tsQIAr7MsQxilMfRiTEoYH0WWthhE0YVQzV6kx4wj4yLGYPPBtFqnrapKKC8yFTpgjaK
 jImqWhU9CSUAXdNEs/oKVR1XlkDpMCFDl88vKAuJwugnixjbPFTVPyoC7+4Bm/FnL3iwlJVE
 qIGQRspt09r+datFzPqSbp5Fo/9m4JSvgtPp2X2+gIGgLPWp2ft1NXHHVWP19sPgEsEJXSr9
 tskM8ScxEkqAUuDs6+x/ISX8wa5Pvmo65drN+JWA8EqKOHQG6LUsUdJolFM2i4Z0k40BnFU/
 kjTARjrXW94LwokVy4x+ZYgImrnKWeKac6fMfMwH2aKpCQLlVxdO4qvJkv92SzZz4538az1T
 m+3ekJAimou89cXwXHCFb5WqJcyjDfdQF857vTn1z4qu7udYCuuV/4xDEhslUq1+GcNDjAhB
 nNYPzD+SvhWEsrjuXv+fDONdJtmLUpKs4Jtak3smGGhZsqpcNv8nQzUGDQZjuCSmDqW8vn2o
 hWwveNeRTkxh+2x1Qb3GT46uzsFNBFH8CgsBEADGC/yx5ctcLQlB9hbq7KNqCDyZNoYu1HAB
 Hal3MuxPfoGKObEktawQPQaSTB5vNlDxKihezLnlT/PKjcXC2R1OjSDinlu5XNGc6mnky03q
 yymUPyiMtWhBBftezTRxWRslPaFWlg/h/Y1iDuOcklhpr7K1h1jRPCrf1yIoxbIpDbffnuyz
 kuto4AahRvBU4Js4sU7f/btU+h+e0AcLVzIhTVPIz7PM+Gk2LNzZ3/on4dnEc/qd+ZZFlOQ4
 KDN/hPqlwA/YJsKzAPX51L6Vv344pqTm6Z0f9M7YALB/11FO2nBB7zw7HAUYqJeHutCwxm7i
 BDNt0g9fhviNcJzagqJ1R7aPjtjBoYvKkbwNu5sWDpQ4idnsnck4YT6ctzN4I+6lfkU8zMzC
 gM2R4qqUXmxFIS4Bee+gnJi0Pc3KcBYBZsDK44FtM//5Cp9DrxRQOh19kNHBlxkmEb8kL/pw
 XIDcEq8MXzPBbxwHKJ3QRWRe5jPNpf8HCjnZz0XyJV0/4M1JvOua7IZftOttQ6KnM4m6WNIZ
 2ydg7dBhDa6iv1oKdL7wdp/rCulVWn8R7+3cRK95SnWiJ0qKDlMbIN8oGMhHdin8cSRYdmHK
 kTnvSGJNlkis5a+048o0C6jI3LozQYD/W9wq7MvgChgVQw1iEOB4u/3FXDEGulRVko6xCBU4
 SQARAQABwsFfBBgBAgAJBQJR/AoLAhsMAAoJEIredpCGysGyfvMQAIywR6jTqix6/fL0Ip8G
 jpt3uk//QNxGJE3ZkUNLX6N786vnEJvc1beCu6EwqD1ezG9fJKMl7F3SEgpYaiKEcHfoKGdh
 30B3Hsq44vOoxR6zxw2B/giADjhmWTP5tWQ9548N4VhIZMYQMQCkdqaueSL+8asp8tBNP+TJ
 PAIIANYvJaD8xA7sYUXGTzOXDh2THWSvmEWWmzok8er/u6ZKdS1YmZkUy8cfzrll/9hiGCTj
 u3qcaOM6i/m4hqtvsI1cOORMVwjJF4+IkC5ZBoeRs/xW5zIBdSUoC8L+OCyj5JETWTt40+lu
 qoqAF/AEGsNZTrwHJYu9rbHH260C0KYCNqmxDdcROUqIzJdzDKOrDmebkEVnxVeLJBIhYZUd
 t3Iq9hdjpU50TA6sQ3mZxzBdfRgg+vaj2DsJqI5Xla9QGKD+xNT6v14cZuIMZzO7w0DoojM4
 ByrabFsOQxGvE0w9Dch2BDSI2Xyk1zjPKxG1VNBQVx3flH37QDWpL2zlJikW29Ws86PHdthh
 Fm5PY8YtX576DchSP6qJC57/eAAe/9ztZdVAdesQwGb9hZHJc75B+VNm4xrh/PJO6c1THqdQ
 19WVJ+7rDx3PhVncGlbAOiiiE3NOFPJ1OQYxPKtpBUukAlOTnkKE6QcA4zckFepUkfmBV1wM
 Jg6OxFYd01z+a+oL
Message-ID: <6145a0d9-fd4e-a739-407e-97f7261eecd8@oracle.com>
Date:   Wed, 15 Jul 2020 16:49:57 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200715194933.GA17938@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150158
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9683 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007150158
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/20 3:49 PM, Anchal Agarwal wrote:
> On Mon, Jul 13, 2020 at 03:43:33PM -0400, Boris Ostrovsky wrote:
>> CAUTION: This email originated from outside of the organization. Do no=
t click links or open attachments unless you can confirm the sender and k=
now the content is safe.
>>
>>
>>
>> On 7/10/20 2:17 PM, Agarwal, Anchal wrote:
>>> Gentle ping on this series.
>>
>> Have you tested save/restore?
>>
> No, not with the last few series. But a good point, I will test that an=
d get
> back to you. Do you see anything specific in the series that suggests o=
therwise?


root@ovs104> xl save pvh saved
Saving to saved new xl format (info 0x3/0x0/1699)
xc: info: Saving domain 3, type x86 HVM
xc: Frames: 1044480/1044480=C2=A0 100%
xc: End of stream: 0/0=C2=A0=C2=A0=C2=A0 0%
root@ovs104> xl restore saved
Loading new save file saved (new xl fmt info 0x3/0x0/1699)
=C2=A0Savefile contains xl domain config in JSON format
Parsing config from <saved>
xc: info: Found x86 HVM domain from Xen 4.13
xc: info: Restoring domain
xc: info: Restore successful
xc: info: XenStore: mfn 0xfeffc, dom 0, evt 1
xc: info: Console: mfn 0xfefff, dom 0, evt 2
root@ovs104> xl console pvh
[=C2=A0 139.943872] ------------[ cut here ]------------
[=C2=A0 139.943872] kernel BUG at arch/x86/xen/enlighten.c:205!
[=C2=A0 139.943872] invalid opcode: 0000 [#1] SMP PTI
[=C2=A0 139.943872] CPU: 0 PID: 11 Comm: migration/0 Not tainted 5.8.0-rc=
5 #26
[=C2=A0 139.943872] RIP: 0010:xen_vcpu_setup+0x16d/0x180
[=C2=A0 139.943872] Code: 4a 8b 14 f5 40 c9 1b 82 48 89 d8 48 89 2c 02 8b=
 05
a4 d4 40 01 85 c0 0f 85 15 ff ff ff 4a 8b 04 f5 40 c9 1b 82 e9 f4 fe ff
ff <0f> 0b b8 ed ff ff ff e9 14 ff ff ff e8 12 4f 86 00 66 90 66 66 66
[=C2=A0 139.943872] RSP: 0018:ffffc9000006bdb0 EFLAGS: 00010046
[=C2=A0 139.943872] RAX: 0000000000000000 RBX: ffffc9000014fe00 RCX:
0000000000000000
[=C2=A0 139.943872] RDX: ffff88803fc00000 RSI: 0000000000016128 RDI:
0000000000000000
[=C2=A0 139.943872] RBP: 0000000000000000 R08: 0000000000000000 R09:
0000000000000000
[=C2=A0 139.943872] R10: ffffffff826174a0 R11: ffffc9000006bcb4 R12:
0000000000016120
[=C2=A0 139.943872] R13: 0000000000016120 R14: 0000000000016128 R15:
0000000000000000
[=C2=A0 139.943872] FS:=C2=A0 0000000000000000(0000) GS:ffff88803fc00000(=
0000)
knlGS:0000000000000000
[=C2=A0 139.943872] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
[=C2=A0 139.943872] CR2: 00007f704be8b000 CR3: 000000003901a004 CR4:
00000000000606f0
[=C2=A0 139.943872] Call Trace:
[=C2=A0 139.943872]=C2=A0 ? __kmalloc+0x167/0x260
[=C2=A0 139.943872]=C2=A0 ? xen_manage_runstate_time+0x14a/0x170
[=C2=A0 139.943872]=C2=A0 xen_vcpu_restore+0x134/0x170
[=C2=A0 139.943872]=C2=A0 xen_hvm_post_suspend+0x1d/0x30
[=C2=A0 139.943872]=C2=A0 xen_arch_post_suspend+0x13/0x30
[=C2=A0 139.943872]=C2=A0 xen_suspend+0x87/0x190
[=C2=A0 139.943872]=C2=A0 multi_cpu_stop+0x6d/0x110
[=C2=A0 139.943872]=C2=A0 ? stop_machine_yield+0x10/0x10
[=C2=A0 139.943872]=C2=A0 cpu_stopper_thread+0x47/0x100
[=C2=A0 139.943872]=C2=A0 smpboot_thread_fn+0xc5/0x160
[=C2=A0 139.943872]=C2=A0 ? sort_range+0x20/0x20
[=C2=A0 139.943872]=C2=A0 kthread+0xfe/0x140
[=C2=A0 139.943872]=C2=A0 ? kthread_park+0x90/0x90
[=C2=A0 139.943872]=C2=A0 ret_from_fork+0x22/0x30
[=C2=A0 139.943872] Modules linked in:
[=C2=A0 139.943872] ---[ end trace 74716859a6b4f0a8 ]---
[=C2=A0 139.943872] RIP: 0010:xen_vcpu_setup+0x16d/0x180
[=C2=A0 139.943872] Code: 4a 8b 14 f5 40 c9 1b 82 48 89 d8 48 89 2c 02 8b=
 05
a4 d4 40 01 85 c0 0f 85 15 ff ff ff 4a 8b 04 f5 40 c9 1b 82 e9 f4 fe ff
ff <0f> 0b b8 ed ff ff ff e9 14 ff ff ff e8 12 4f 86 00 66 90 66 66 66
[=C2=A0 139.943872] RSP: 0018:ffffc9000006bdb0 EFLAGS: 00010046
[=C2=A0 139.943872] RAX: 0000000000000000 RBX: ffffc9000014fe00 RCX:
0000000000000000
[=C2=A0 139.943872] RDX: ffff88803fc00000 RSI: 0000000000016128 RDI:
0000000000000000
[=C2=A0 139.943872] RBP: 0000000000000000 R08: 0000000000000000 R09:
0000000000000000
[=C2=A0 139.943872] R10: ffffffff826174a0 R11: ffffc9000006bcb4 R12:
0000000000016120
[=C2=A0 139.943872] R13: 0000000000016120 R14: 0000000000016128 R15:
0000000000000000
[=C2=A0 139.943872] FS:=C2=A0 0000000000000000(0000) GS:ffff88803fc00000(=
0000)
knlGS:0000000000000000
[=C2=A0 139.943872] CS:=C2=A0 0010 DS: 0000 ES: 0000 CR0: 000000008005003=
3
[=C2=A0 139.943872] CR2: 00007f704be8b000 CR3: 000000003901a004 CR4:
00000000000606f0
[=C2=A0 139.943872] Kernel panic - not syncing: Fatal exception
[=C2=A0 139.943872] Shutting down cpus with NMI
[=C2=A0 143.927559] Kernel Offset: disabled
root@ovs104>

