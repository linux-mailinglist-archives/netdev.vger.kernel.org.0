Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7714E6DDF24
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 17:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbjDKPMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 11:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjDKPLw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 11:11:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9E55BB0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 08:11:35 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33BEifkQ018691;
        Tue, 11 Apr 2023 15:11:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : content-type : mime-version; s=pp1;
 bh=MZIuF1ZdwWLML83NcTlwp7ajykIeJakmPFKTVxj72Pc=;
 b=HafzvLAhO5KHgLBad2/lys6B4u6kN8wO8L/OyAbTRV4/c0QogdQL8Wup5ugxXefzyhPm
 SwCqMAZ4edTwki/bBia79uK03XKZ/Yb7IAwvNwG108TJYNz3p2NzoexS2V5c0RZLoeou
 Pfta38V/KyvniHJl2ZIqTTC3U/VdzWoiVYs8U2G9suvyleEr51mYFYxaOP++UVGknxBD
 6WdUBqXE4JcM7dD0s9f70PVRVQntvTKwVLlKx20DB0MbHaLJI0JYuI8LJYGqGSkF77dy
 +QW/pxDKco1Oc5cObvji0moCYpMemGBXix+GiyDRldaxbTSXPJcdYY1uFQc16j95HNrE 2w== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pw9juh8yd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Apr 2023 15:11:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33AGIfXI032371;
        Tue, 11 Apr 2023 15:11:17 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pu0m19t1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Apr 2023 15:11:17 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33BFBCfP31130106
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Apr 2023 15:11:12 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A6F572004D;
        Tue, 11 Apr 2023 15:11:12 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 20FB72004B;
        Tue, 11 Apr 2023 15:11:12 +0000 (GMT)
Received: from [9.171.53.122] (unknown [9.171.53.122])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Apr 2023 15:11:12 +0000 (GMT)
Message-ID: <90e1efad457f40c1f9f7b8cb56852072d8ea00fd.camel@linux.ibm.com>
Subject: Kernel crash after FLR reset of a ConnectX-5 PF in switchdev mode
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     Gerd Bayer <gbayer@linux.ibm.com>,
        "alexander.sschmidt" <alexander.sschmidt@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        netdev@vger.kernel.org
Date:   Tue, 11 Apr 2023 17:11:11 +0200
Content-Type: multipart/mixed; boundary="=-eYGpCmT4UMD9DC6zFMZP"
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: W2poOy14EOV2-gv1StO9HX1DzIMyx5cj
X-Proofpoint-GUID: W2poOy14EOV2-gv1StO9HX1DzIMyx5cj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-11_10,2023-04-11_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 adultscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2303200000 definitions=main-2304110133
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-eYGpCmT4UMD9DC6zFMZP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Saeed, Hi Leon,

While testing PCI recovery with a ConnectX-5 card (MT28800, fw
16.35.1012) and vanilla 6.3-rc4/5/6 on s390 I've run into a kernel
crash (stacktrace attached) when the card is in switchdev mode. No
crash occurs and the recovery succeeds in legacy mode (with VFs). I
found that the same crash occurs also with a simple Function Level
Reset instead of the s390 specific PCI recovery, see instructions
below. From the looks of it I think this could affect non-s390 too but
I don't have a proper x86 test system with a ConnectX card to test
with.

Anyway, I tried to analyze further but got stuck after figuring out
that in mlx5e_remove() deep down from mlx5_fw_fatal_reporter_err_work()
(see trace) the mlx5e_dev->priv pointer is valid but the pointed to
struct only contains zeros as it was previously zeroed by
mlx5_mdev_uninit() which then leads to a NULL pointer access.

The crash itself can be prevented by the following debug patch though
clearly this is not a proper fix:

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -6012,6 +6012,10 @@ static void mlx5e_remove(struct auxiliary_device
*adev)
        struct mlx5e_priv *priv =3D mlx5e_dev->priv;
        pm_message_t state =3D {};

+       if (!priv->mdev) {
+               pr_err("%s with zeroed mlx5e_dev->priv\n", __func__);
+               return;
+       }
        mlx5_core_uplink_netdev_set(priv->mdev, NULL);
        mlx5e_dcbnl_delete_app(priv);
        unregister_netdev(priv->netdev);

With that I then tried to track down why mlx5_mdev_uninit() is called
and this might actually be s390 specific in that this happens during
the removal of the VF which on s390 causes extra hot unplug events for
the VFs (our virtualized PCI hotplug is per-PCI function) resulting in
the following call trace:

...
zpci_bus_remove_device()
   zpci_iov_remove_virtfn()
      pci_iov_remove_virtfn()
         pci_stop_and_remove_bus_device()
            pci_stop_bus_device()
               device_release_driver_internal()
                  pci_device_remove()
                     remove_one()
                        mlx5_mdev_uninit()

Then again I would expect that on other architectures VFs become at
leastunresponsive during a FLR of the PF not sure if that also lead to
calls to remove_one() though.

As another data point I tried the same on the default Ubuntu 22.04
generic 5.15 kernel and there no crash occurs so this might be a newer
issue.

Also, I did test with and without the patch I sent recently for
skipping the wait in mlx5_health_wait_pci_up() but that made no
difference.

Any hints on how to debug this further and could you try to see if this
occurs on other architectures as well?

Thanks,
Niklas

Reproduced with (0004:00:00.0 being the first PF of a ConnectX-5):

$ devlink dev eswitch set pci/0004:00:00.0 mode switchdev
$ devlink dev eswitch set pci/0004:00:00.1 mode switchdev

The next 2 lines are needed on s390 due to an unrelated issue with smsf mod=
e.

$ devlink dev param set pci/0004:00:00.0 name flow_steering_mode value dmfs=
 cmode runtime
$ devlink dev param set pci/0004:00:00.1 name flow_steering_mode value dmfs=
 cmode runtime
$ echo 1 > /sys/bus/pci/devices/0004:00:00.0/sriov_numvfs
# Check the reset method is FLR though others might also cause this
$ cat /sys/bus/pci/devices/0004:00:00.0/reset_method
flr

Then to trigger the crash (after a bit of recovery, it may be racy though i=
t hits pretty
consistently for me)

$ echo 1 > /sys/bus/pci/devices/0004:00:00.0/reset

--=-eYGpCmT4UMD9DC6zFMZP
Content-Disposition: attachment; filename="mlx5_switchdev_reset_crash_backtrace.txt"
Content-Type: text/plain; name="mlx5_switchdev_reset_crash_backtrace.txt";
	charset="UTF-8"
Content-Transfer-Encoding: base64

WyAxMzQ2Ljk4NzQxNF0gbWx4NV9jb3JlIDAwMDM6MDA6MDAuMCBlbnM4NzA0ZjBucDA6IExpbmsg
dXAKWyAxMzQ3LjAwNjg0NV0gSVB2NjogQUREUkNPTkYoTkVUREVWX0NIQU5HRSk6IGVuczg3MDRm
MG5wMDogbGluayBiZWNvbWVzIHJlYWR5ClsgMTM1Ni41MTg2NjldIG1seDVfY29yZSAwMDA0OjAw
OjAwLjA6IEUtU3dpdGNoOiBEaXNhYmxlOiBtb2RlKExFR0FDWSksIG52ZnMoMCksIGFjdGl2ZSB2
cG9ydHMoMCkKWyAxMzU5LjE5MjA0OV0gbWx4NV9jb3JlIDAwMDQ6MDA6MDAuMCBlbnM4ODMyZjBu
cDA6IERyb3BwaW5nIEMtdGFnIHZsYW4gc3RyaXBwaW5nIG9mZmxvYWQgZHVlIHRvIFMtdGFnIHZs
YW4KWyAxMzU5LjE5MjE1Ml0gbWx4NV9jb3JlIDAwMDQ6MDA6MDAuMCBlbnM4ODMyZjBucDA6IERp
c2FibGluZyBIV19WTEFOIENUQUcgRklMVEVSSU5HLCBub3Qgc3VwcG9ydGVkIGluIHN3aXRjaGRl
diBtb2RlClsgMTM1OS4zNjUzNzBdIG1seDVfY29yZSAwMDA0OjAwOjAwLjA6IEUtU3dpdGNoOiBF
bmFibGU6IG1vZGUoT0ZGTE9BRFMpLCBudmZzKDApLCBhY3RpdmUgdnBvcnRzKDEpClsgMTM1OS4z
NjU5NTJdIGRldmxpbmsgKDE1ODYpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDc1NTIgYnl0
ZXMgbGVmdApbIDEzNTkuNDQ4NjM4XSBtbHg1X2NvcmUgMDAwNDowMDowMC4xOiBFLVN3aXRjaDog
RGlzYWJsZTogbW9kZShMRUdBQ1kpLCBudmZzKDApLCBhY3RpdmUgdnBvcnRzKDApClsgMTM2MS4y
NTY2NzFdIGRlYnVnZnM6IERpcmVjdG9yeSAnbWx4NV9kcl9jaHVua3MnIHdpdGggcGFyZW50ICdz
bGFiJyBhbHJlYWR5IHByZXNlbnQhClsgMTM2MS4yNTcyOTVdIGRlYnVnZnM6IERpcmVjdG9yeSAn
bWx4NV9kcl9odGJscycgd2l0aCBwYXJlbnQgJ3NsYWInIGFscmVhZHkgcHJlc2VudCEKWyAxMzYy
LjA2MzQzM10gbWx4NV9jb3JlIDAwMDQ6MDA6MDAuMSBlbnM4ODk2ZjFucDE6IERyb3BwaW5nIEMt
dGFnIHZsYW4gc3RyaXBwaW5nIG9mZmxvYWQgZHVlIHRvIFMtdGFnIHZsYW4KWyAxMzYyLjA2MzU2
MF0gbWx4NV9jb3JlIDAwMDQ6MDA6MDAuMSBlbnM4ODk2ZjFucDE6IERpc2FibGluZyBIV19WTEFO
IENUQUcgRklMVEVSSU5HLCBub3Qgc3VwcG9ydGVkIGluIHN3aXRjaGRldiBtb2RlClsgMTM2Mi4y
NDA4OTldIG1seDVfY29yZSAwMDA0OjAwOjAwLjE6IEUtU3dpdGNoOiBFbmFibGU6IG1vZGUoT0ZG
TE9BRFMpLCBudmZzKDApLCBhY3RpdmUgdnBvcnRzKDEpClsgMTM2Mi4yNDE1MjddIGRldmxpbmsg
KDE1OTUpIHVzZWQgZ3JlYXRlc3Qgc3RhY2sgZGVwdGg6IDc1MjAgYnl0ZXMgbGVmdApbIDEzNjIu
MzI3MzAxXSBtbHg1X2NvcmUgMDAwNDowMDowMC4wIGVuczg4MzJmMG5wMDogTGluayB1cApbIDEz
NjIuMzQ1MzUzXSBJUHY2OiBBRERSQ09ORihORVRERVZfQ0hBTkdFKTogZW5zODgzMmYwbnAwOiBs
aW5rIGJlY29tZXMgcmVhZHkKWyAxMzYyLjM0NjE2OV0gaXAgKDE2MDMpIHVzZWQgZ3JlYXRlc3Qg
c3RhY2sgZGVwdGg6IDczNjggYnl0ZXMgbGVmdApbIDEzNjIuNDM3MDQ0XSBwY2kgMDAwNDowMDow
MC4yOiBbMTViMzoxMDFhXSB0eXBlIDAwIGNsYXNzIDB4MDIwMDAwClsgMTM2Mi40MzcyNzddIHBj
aSAwMDA0OjAwOjAwLjI6IHJlZyAweDEwOiBbbWVtIDB4ZmZmZmMwMDAwMjAwMDAwMC0weGZmZmZj
MDAwMDIxZmZmZmYgNjRiaXQgcHJlZl0KWyAxMzYyLjQzNzQyM10gcGNpIDAwMDQ6MDA6MDAuMjog
ZW5hYmxpbmcgRXh0ZW5kZWQgVGFncwpbIDEzNjIuNDM4NjE5XSBwY2kgMDAwNDowMDowMC4yOiBB
ZGRpbmcgdG8gaW9tbXUgZ3JvdXAgMzAKWyAxMzYyLjQ0MDY0MF0gbWx4NV9jb3JlIDAwMDQ6MDA6
MDAuMjogZW5hYmxpbmcgZGV2aWNlICgwMDAwIC0+IDAwMDIpClsgMTM2Mi40NDA4MTBdIG1seDVf
Y29yZSAwMDA0OjAwOjAwLjI6IGZpcm13YXJlIHZlcnNpb246IDE2LjM1LjEwMTIKWyAxMzYyLjY3
NTc5NV0gbWx4NV9jb3JlIDAwMDQ6MDA6MDAuMjogUmF0ZSBsaW1pdDogMTI3IHJhdGVzIGFyZSBz
dXBwb3J0ZWQsIHJhbmdlOiAwTWJwcyB0byA5NzY1Nk1icHMKWyAxMzYyLjY3NjcxMV0gZGVidWdm
czogRGlyZWN0b3J5ICdtbHg1X2ZzX2Zncycgd2l0aCBwYXJlbnQgJ3NsYWInIGFscmVhZHkgcHJl
c2VudCEKWyAxMzYyLjY3NzI3OF0gZGVidWdmczogRGlyZWN0b3J5ICdtbHg1X2ZzX2Z0ZXMnIHdp
dGggcGFyZW50ICdzbGFiJyBhbHJlYWR5IHByZXNlbnQhClsgMTM2Mi42OTY4NDddIG1seDVfY29y
ZSAwMDA0OjAwOjAwLjI6IEFzc2lnbmVkIHJhbmRvbSBNQUMgYWRkcmVzcyAwMjowZTo4YTpjNzo5
Mzo5YQpbIDEzNjIuODMwNDMyXSBtbHg1X2NvcmUgMDAwNDowMDowMC4yOiBNTFg1RTogU3RyZFJx
KDEpIFJxU3ooMTYpIFN0cmRTeig0MDk2KSBSeENxZUNtcHJzcygwIGJhc2ljKQpbIDEzNjIuODM1
MjAzXSBtbHg1X2NvcmUgMDAwNDowMDowMC4yIGVuczg4MzJmMHYwOiByZW5hbWVkIGZyb20gZXRo
MQpbIDEzNzIuNzY4NjQ1XSBtbHg1X2NvcmUgMDAwNDowMDowMC4yOiBwb2xsX2hlYWx0aDo4MTg6
KHBpZCAwKTogRmF0YWwgZXJyb3IgMSBkZXRlY3RlZApbIDEzNzIuNzY4NzkxXSBtbHg1X2NvcmUg
MDAwNDowMDowMC4yOiBwcmludF9oZWFsdGhfaW5mbzo0MjM6KHBpZCAwKTogUENJIHNsb3QgaXMg
dW5hdmFpbGFibGUKWyAxMzczLjE2ODU0NF0gbWx4NV9jb3JlIDAwMDQ6MDA6MDAuMDogcG9sbF9o
ZWFsdGg6ODE4OihwaWQgMCk6IEZhdGFsIGVycm9yIDMgZGV0ZWN0ZWQKWyAxMzc1LjQzNDM4N10g
bWx4NV9jb3JlIDAwMDQ6MDA6MDAuMDogbWx4NV9oZWFsdGhfdHJ5X3JlY292ZXI6MzM1OihwaWQg
MTUwNSk6IGhhbmRsaW5nIGJhZCBkZXZpY2UgaGVyZQpbIDEzNzUuNDM0NTAyXSBtbHg1X2NvcmUg
MDAwNDowMDowMC4wOiBtbHg1X2hhbmRsZV9iYWRfc3RhdGU6MjkyOihwaWQgMTUwNSk6IHN0YXJ0
aW5nIHRlYXJkb3duClsgMTM3NS40MzQ1NDVdIG1seDVfY29yZSAwMDA0OjAwOjAwLjA6IG1seDVf
ZXJyb3Jfc3dfcmVzZXQ6MjQzOihwaWQgMTUwNSk6IHN0YXJ0ClsgMTM3NS40MzQ1ODZdIG1seDVf
Y29yZSAwMDA0OjAwOjAwLjA6IG1seDVfZXJyb3Jfc3dfcmVzZXQ6Mjc2OihwaWQgMTUwNSk6IGVu
ZApbIDEzNzUuNzcxMzk1XSBtbHg1X2NvcmUgMDAwNDowMDowMC4wIGV0aDAgKHVucmVnaXN0ZXJp
bmcpOiB2cG9ydCAxIGVycm9yIC02NyByZWFkaW5nIHN0YXRzClsgMTM3Ni4xNTEzNDVdIG1seDVf
Y29yZSAwMDA0OjAwOjAwLjA6IG1seDVlX2luaXRfbmljX3R4OjUzNzY6KHBpZCAxNTA1KTogY3Jl
YXRlIHRpc2VzIGZhaWxlZCwgLTY3ClsgMTM3Ni4yMzg4MDhdIG1seDVfY29yZSAwMDA0OjAwOjAw
LjAgZW5zODgzMmYwbnAwOiBtbHg1ZV9uZXRkZXZfY2hhbmdlX3Byb2ZpbGU6IG5ldyBwcm9maWxl
IGluaXQgZmFpbGVkLCAtNjcKWyAxMzc2LjI0Mzc0Nl0gbWx4NV9jb3JlIDAwMDQ6MDA6MDAuMDog
bWx4NWVfaW5pdF9yZXBfdHg6MTEwMToocGlkIDE1MDUpOiBjcmVhdGUgdGlzZXMgZmFpbGVkLCAt
NjcKWyAxMzc2LjMyODYyM10gbWx4NV9jb3JlIDAwMDQ6MDA6MDAuMCBlbnM4ODMyZjBucDA6IG1s
eDVlX25ldGRldl9jaGFuZ2VfcHJvZmlsZTogZmFpbGVkIHRvIHJvbGxiYWNrIHRvIG9yaWcgcHJv
ZmlsZSwgLTY3ClsgMTM3Ni4zMjkxNTldIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0tLS0t
LS0tLQpbIDEzNzYuMzI5MTYxXSBERUJVR19MT0NLU19XQVJOX09OKGxvY2stPm1hZ2ljICE9IGxv
Y2spClsgMTM3Ni4zMjkxNzFdIFdBUk5JTkc6IENQVTogNiBQSUQ6IDE1MDUgYXQga2VybmVsL2xv
Y2tpbmcvbXV0ZXguYzo1ODIgX19tdXRleF9sb2NrKzB4YmM2LzB4ZmE4ClsgMTM3Ni4zMjkxODJd
IE1vZHVsZXMgbGlua2VkIGluOiBrdm0gbmZ0X2ZpYl9pbmV0IG5mdF9maWJfaXB2NCBuZnRfZmli
X2lwdjYgbmZ0X2ZpYiBuZnRfcmVqZWN0X2luZXQgbmZfcmVqZWN0X2lwdjQgbmZfcmVqZWN0X2lw
djYgbmZ0X3JlamVjdCBuZnRfY3QgbmZ0X2NoYWluX25hdCBuZl9uYXQgbmZfY29ubnRyYWNrIG5m
X2RlZnJhZ19pcHY2IG5mX2RlZnJhZ19pcHY0IGlwX3NldCBuZl90YWJsZXMgbmZuZXRsaW5rIHV2
ZGV2aWNlIHMzOTBfdHJuZyBzdW5ycGMgbWx4NV9pYiBpYl91dmVyYnMgaWJfY29yZSBpc20gZWFk
bV9zY2ggdmZpb19jY3cgbWRldiB2CmZpb19pb21tdV90eXBlMSB2ZmlvIHNjaF9mcV9jb2RlbCBs
b29wIGNvbmZpZ2ZzIGdoYXNoX3MzOTAgcHJuZyBjaGFjaGFfczM5MCBsaWJjaGFjaGEgYWVzX3Mz
OTAgZGVzX3MzOTAgbGliZGVzIHNoYTNfNTEyX3MzOTAgc2hhM18yNTZfczM5MCBzaGE1MTJfczM5
MCBzaGEyNTZfczM5MCBzaGExX3MzOTAgc2hhX2NvbW1vbiBudm1lIG1seDVfY29yZSBudm1lX2Nv
cmUgcGtleSB6Y3J5cHQgcm5nX2NvcmUgYXV0b2ZzNApbIDEzNzYuMzI5MjMwXSBDUFU6IDYgUElE
OiAxNTA1IENvbW06IGt3b3JrZXIvdTgwMDozIE5vdCB0YWludGVkIDYuMy4wLXJjNCAjNDkKWyAx
Mzc2LjMyOTIzM10gSGFyZHdhcmUgbmFtZTogSUJNIDM5MzEgQTAxIDcwNCAoTFBBUikKWyAxMzc2
LjMyOTIzNV0gV29ya3F1ZXVlOiBtbHg1X2hlYWx0aDAwMDQ6MDA6MDAuMCBtbHg1X2Z3X2ZhdGFs
X3JlcG9ydGVyX2Vycl93b3JrIFttbHg1X2NvcmVdClsgMTM3Ni4zMjkzNDVdIEtybmwgUFNXIDog
MDcwNGQwMDE4MDAwMDAwMCAwMDAwMDAwMGVlODI3OTkyIChfX211dGV4X2xvY2srMHhiY2EvMHhm
YTgpClsgMTM3Ni4zMjkzNTFdICAgICAgICAgICAgUjowIFQ6MSBJTzoxIEVYOjEgS2V5OjAgTTox
IFc6MCBQOjAgQVM6MyBDQzoxIFBNOjAgUkk6MCBFQTozClsgMTM3Ni4zMjkzNTRdIEtybmwgR1BS
UzogYzAwMDAwMDBmZmZlZmZmZiAwMDAwMDAwMDgwMDAwMDAxIDAwMDAwMDAwMDAwMDAwMjggMDAw
MDAwMDBlZWM5MDE5OApbIDEzNzYuMzI5MzU3XSAgICAgICAgICAgIDAwMDAwMzgwMDRhZjM2Yjgg
MDAwMDAzODAwNGFmMzZiMCAwMDAwMDNmZjdmYmNkZmQ4IDAwMDAwMDAwMDAwMDAwODAKWyAxMzc2
LjMyOTM1OV0gICAgICAgICAgICAwMDAwMDAwMGYwMzgzOWE4IDAwMDAwMDAwMDAwMDAwMDAgMDAw
MDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDU5ZmU4ClsgMTM3Ni4zMjkzNjFdICAgICAgICAgICAg
MDAwMDAwMDA5ZmE1ODEwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwZWU4Mjc5OGUgMDAwMDAz
ODAwNGFmMzg0OApbIDEzNzYuMzI5MzY4XSBLcm5sIENvZGU6IDAwMDAwMDAwZWU4Mjc5ODI6IGMw
MjAwMDFlZjRhMSAgICAgICAgbGFybCAgICAlcjIsMDAwMDAwMDBlZWMwNjJjNApbIDEzNzYuMzI5
MzY4XSAgICAgICAgICAgIDAwMDAwMDAwZWU4Mjc5ODg6IGMwZTVmZjkwYzMxOCAgICAgICAgYnJh
c2wgICAlcjE0LDAwMDAwMDAwZWRhM2ZmYjgKWyAxMzc2LjMyOTM2OF0gICAgICAgICAgICMwMDAw
MDAwMGVlODI3OThlOiBhZjAwMDAwMCAgICAgICAgICAgIG1jICAgICAgMCwwClsgMTM3Ni4zMjkz
NjhdICAgICAgICAgICA+MDAwMDAwMDBlZTgyNzk5MjogYTdmNGZhNGQgICAgICAgICAgICBicmMg
ICAgIDE1LDAwMDAwMDAwZWU4MjZlMmMKWyAxMzc2LjMyOTM2OF0gICAgICAgICAgICAwMDAwMDAw
MGVlODI3OTk2OiBhZjAwMDAwMCAgICAgICAgICAgIG1jICAgICAgMCwwClsgMTM3Ni4zMjkzNjhd
ICAgICAgICAgICAgMDAwMDAwMDBlZTgyNzk5YTogYTdmNGZhZjQgICAgICAgICAgICBicmMgICAg
IDE1LDAwMDAwMDAwZWU4MjZmODIKWyAxMzc2LjMyOTM2OF0gICAgICAgICAgICAwMDAwMDAwMGVl
ODI3OTllOiBlMzEwMDM0MDAwMDQgICAgICAgIGxnICAgICAgJXIxLDgzMgpbIDEzNzYuMzI5MzY4
XSAgICAgICAgICAgIDAwMDAwMDAwZWU4Mjc5YTQ6IGUzMjAxMDAwMDAwNCAgICAgICAgbGcgICAg
ICAlcjIsMCglcjEpClsgMTM3Ni4zMjk0MDVdIENhbGwgVHJhY2U6ClsgMTM3Ni4zMjk0MDZdICBb
PDAwMDAwMDAwZWU4Mjc5OTI+XSBfX211dGV4X2xvY2srMHhiY2EvMHhmYTggClsgMTM3Ni4zMjk0
MDldIChbPDAwMDAwMDAwZWU4Mjc5OGU+XSBfX211dGV4X2xvY2srMHhiYzYvMHhmYTgpClsgMTM3
Ni4zMjk0MTJdICBbPDAwMDAwMDAwZWU4MjdkYTI+XSBtdXRleF9sb2NrX25lc3RlZCsweDMyLzB4
NDAgClsgMTM3Ni4zMjk0MTZdICBbPDAwMDAwM2ZmN2ZiY2RmZDg+XSBtbHg1X2NvcmVfdXBsaW5r
X25ldGRldl9zZXQrMHgzOC8weDYwIFttbHg1X2NvcmVdIApbIDEzNzYuMzI5NDY5XSAgWzwwMDAw
MDNmZjdmYzExMDBjPl0gbWx4NWVfcmVtb3ZlKzB4M2MvMHhhMCBbbWx4NV9jb3JlXSAKWyAxMzc2
LjMyOTUyMV0gIFs8MDAwMDAwMDBlZTQyZmE3Yz5dIGRldmljZV9yZWxlYXNlX2RyaXZlcl9pbnRl
cm5hbCsweDFjNC8weDI3MCAKWyAxMzc2LjMyOTUyNl0gIFs8MDAwMDAwMDBlZTQyZDc4OD5dIGJ1
c19yZW1vdmVfZGV2aWNlKzB4MTAwLzB4MTg4IApbIDEzNzYuMzI5NTI4XSAgWzwwMDAwMDAwMGVl
NDI3MjRlPl0gZGV2aWNlX2RlbCsweDE4Ni8weDNiOCAKWyAxMzc2LjMyOTUzM10gIFs8MDAwMDAz
ZmY3ZmJmNjEzND5dIG1seDVfZGV0YWNoX2RldmljZSsweGFjLzB4MTEwIFttbHg1X2NvcmVdIApb
IDEzNzYuMzI5NTgzXSAgWzwwMDAwMDNmZjdmYmNmODEyPl0gbWx4NV91bmxvYWRfb25lX2Rldmxf
bG9ja2VkKzB4NTIvMHhjOCBbbWx4NV9jb3JlXSAKWyAxMzc2LjMyOTYzNV0gIFs8MDAwMDAzZmY3
ZmM3NzdlOD5dIG1seDVfaGVhbHRoX3RyeV9yZWNvdmVyKzB4MTY4LzB4MjQwIFttbHg1X2NvcmVd
IApbIDEzNzYuMzI5Njg3XSAgWzwwMDAwMDAwMGVlNzJiOWQyPl0gZGV2bGlua19oZWFsdGhfcmVw
b3J0ZXJfcmVjb3ZlcisweDNhLzB4OTggClsgMTM3Ni4zMjk2OTBdICBbPDAwMDAwMDAwZWU3MmJi
M2M+XSBkZXZsaW5rX2hlYWx0aF9yZXBvcnQrMHgxMGMvMHgzMDAgClsgMTM3Ni4zMjk2OTNdICBb
PDAwMDAwM2ZmN2ZiZGQwYWM+XSBtbHg1X2Z3X2ZhdGFsX3JlcG9ydGVyX2Vycl93b3JrKzB4YzQv
MHgxZDggW21seDVfY29yZV0gClsgMTM3Ni4zMjk3NDRdICBbPDAwMDAwMDAwZWRhNmI5MzQ+XSBw
cm9jZXNzX29uZV93b3JrKzB4MzBjLzB4Njg4IApbIDEzNzYuMzI5NzQ5XSAgWzwwMDAwMDAwMGVk
YTZiZDEyPl0gd29ya2VyX3RocmVhZCsweDYyLzB4NDM4IApbIDEzNzYuMzI5NzUyXSAgWzwwMDAw
MDAwMGVkYTc3NDAwPl0ga3RocmVhZCsweDEzOC8weDE1MCAKWyAxMzc2LjMyOTc1Nl0gIFs8MDAw
MDAwMDBlZDllYjg5ND5dIF9fcmV0X2Zyb21fZm9yaysweDNjLzB4NTggClsgMTM3Ni4zMjk3NTld
ICBbPDAwMDAwMDAwZWU4MzA5ZGE+XSByZXRfZnJvbV9mb3JrKzB4YS8weDQwIApbIDEzNzYuMzI5
NzYyXSBJTkZPOiBsb2NrZGVwIGlzIHR1cm5lZCBvZmYuClsgMTM3Ni4zMjk3NjRdIExhc3QgQnJl
YWtpbmctRXZlbnQtQWRkcmVzczoKWyAxMzc2LjMyOTc2NV0gIFs8MDAwMDAwMDBlZGE0MDBlND5d
IF9fd2Fybl9wcmludGsrMHgxMmMvMHgxMzgKWyAxMzc2LjMyOTc3MF0gaXJxIGV2ZW50IHN0YW1w
OiA5ODc0MTMKWyAxMzc2LjMyOTc3Ml0gaGFyZGlycXMgbGFzdCAgZW5hYmxlZCBhdCAoOTg3NDEz
KTogWzwwMDAwMDAwMGVlODJmYWI2Pl0gX3Jhd19zcGluX3VubG9ja19pcnFyZXN0b3JlKzB4NzYv
MHhjMApbIDEzNzYuMzI5Nzc0XSBoYXJkaXJxcyBsYXN0IGRpc2FibGVkIGF0ICg5ODc0MTIpOiBb
PDAwMDAwMDAwZWU4MmY2YjY+XSBfcmF3X3NwaW5fbG9ja19pcnFzYXZlKzB4OWUvMHhkOApbIDEz
NzYuMzI5Nzc5XSBzb2Z0aXJxcyBsYXN0ICBlbmFibGVkIGF0ICg5ODY3NTQpOiBbPDAwMDAwMDAw
ZWU0ZWM0MGU+XSBuZXRpZl9zZXRfcmVhbF9udW1fdHhfcXVldWVzKzB4MTE2LzB4MjcwClsgMTM3
Ni4zMjk3ODRdIHNvZnRpcnFzIGxhc3QgZGlzYWJsZWQgYXQgKDk4Njc1Mik6IFs8MDAwMDAwMDBl
ZTRlYzNmYT5dIG5ldGlmX3NldF9yZWFsX251bV90eF9xdWV1ZXMrMHgxMDIvMHgyNzAKWyAxMzc2
LjMyOTc4N10gLS0tWyBlbmQgdHJhY2UgMDAwMDAwMDAwMDAwMDAwMCBdLS0tClsgMTM3Ni4zMjk3
OTJdIFVuYWJsZSB0byBoYW5kbGUga2VybmVsIHBvaW50ZXIgZGVyZWZlcmVuY2UgaW4gdmlydHVh
bCBrZXJuZWwgYWRkcmVzcyBzcGFjZQpbIDEzNzYuMzI5Nzk0XSBGYWlsaW5nIGFkZHJlc3M6IGE3
MTkwMDAxZWIxMTIwMDAgVEVJRDogYTcxOTAwMDFlYjExMjgwMwpbIDEzNzYuMzI5Nzk2XSBGYXVs
dCBpbiBob21lIHNwYWNlIG1vZGUgd2hpbGUgdXNpbmcga2VybmVsIEFTQ0UuClsgMTM3Ni4zMjk4
MDFdIEFTOjAwMDAwMDAwZWY4NjgwMDcgUjM6MDAwMDAwMDAwMDAwMDAyNCAKWyAxMzc2LjMyOTgz
MV0gT29wczogMDAzOCBpbGM6MiBbIzFdIFBSRUVNUFQgU01QIApbIDEzNzYuMzI5ODM0XSBNb2R1
bGVzIGxpbmtlZCBpbjoga3ZtIG5mdF9maWJfaW5ldCBuZnRfZmliX2lwdjQgbmZ0X2ZpYl9pcHY2
IG5mdF9maWIgbmZ0X3JlamVjdF9pbmV0IG5mX3JlamVjdF9pcHY0IG5mX3JlamVjdF9pcHY2IG5m
dF9yZWplY3QgbmZ0X2N0IG5mdF9jaGFpbl9uYXQgbmZfbmF0IG5mX2Nvbm50cmFjayBuZl9kZWZy
YWdfaXB2NiBuZl9kZWZyYWdfaXB2NCBpcF9zZXQgbmZfdGFibGVzIG5mbmV0bGluayB1dmRldmlj
ZSBzMzkwX3Rybmcgc3VucnBjIG1seDVfaWIgaWJfdXZlcmJzIGliX2NvcmUgaXNtIGVhZG1fc2No
IHZmaW9fY2N3IG1kZXYgdgpmaW9faW9tbXVfdHlwZTEgdmZpbyBzY2hfZnFfY29kZWwgbG9vcCBj
b25maWdmcyBnaGFzaF9zMzkwIHBybmcgY2hhY2hhX3MzOTAgbGliY2hhY2hhIGFlc19zMzkwIGRl
c19zMzkwIGxpYmRlcyBzaGEzXzUxMl9zMzkwIHNoYTNfMjU2X3MzOTAgc2hhNTEyX3MzOTAgc2hh
MjU2X3MzOTAgc2hhMV9zMzkwIHNoYV9jb21tb24gbnZtZSBtbHg1X2NvcmUgbnZtZV9jb3JlIHBr
ZXkgemNyeXB0IHJuZ19jb3JlIGF1dG9mczQKWyAxMzc2LjMyOTg3Nl0gQ1BVOiA2IFBJRDogMTUw
NSBDb21tOiBrd29ya2VyL3U4MDA6MyBUYWludGVkOiBHICAgICAgICBXICAgICAgICAgIDYuMy4w
LXJjNCAjNDkKWyAxMzc2LjMyOTg3OF0gSGFyZHdhcmUgbmFtZTogSUJNIDM5MzEgQTAxIDcwNCAo
TFBBUikKWyAxMzc2LjMyOTg4MF0gV29ya3F1ZXVlOiBtbHg1X2hlYWx0aDAwMDQ6MDA6MDAuMCBt
bHg1X2Z3X2ZhdGFsX3JlcG9ydGVyX2Vycl93b3JrIFttbHg1X2NvcmVdClsgMTM3Ni4zMjk5MzNd
IEtybmwgUFNXIDogMDcwNGQwMDE4MDAwMDAwMCAwMDAwMDAwMGVlODI3N2M0IChfX211dGV4X2xv
Y2srMHg5ZmMvMHhmYTgpClsgMTM3Ni4zMjk5MzhdICAgICAgICAgICAgUjowIFQ6MSBJTzoxIEVY
OjEgS2V5OjAgTToxIFc6MCBQOjAgQVM6MyBDQzoxIFBNOjAgUkk6MCBFQTozClsgMTM3Ni4zMjk5
NDFdIEtybmwgR1BSUzogYzAwMDAwMDBmZmZlZmZmZiAwMDAwMDAwMDlmYTU4MTAwIGE3MTkwMDAx
ZWIxMTIwMDAgYTcxOTAwMDFlYjExMjAwMApbIDEzNzYuMzI5OTQ0XSAgICAgICAgICAgIDAwMDAw
MDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMGVlZTJjZDYwIGE3MTkwMDAxZWIx
MTIwMDAKWyAxMzc2LjMyOTk0Nl0gICAgICAgICAgICAwMDAwMDAwMGYwMzgzOWE4IDAwMDAwMDAw
ZWVlMmNhNDggMDAwMDAwMDAwMDA1YTA1OCAwMDAwMDAwMDAwMDU5ZmU4ClsgMTM3Ni4zMjk5NDld
ICAgICAgICAgICAgMDAwMDAwMDA5ZmE1ODEwMCAwMDAwMDAwMDlmYTU4MTAwIDAwMDAwMDAwZWU4
MjczOTYgMDAwMDAzODAwNGFmMzg0OApbIDEzNzYuMzI5OTUzXSBLcm5sIENvZGU6IDAwMDAwMDAw
ZWU4Mjc3YjY6IGMwZTVmZmZmZTk3ZCAgICAgICAgYnJhc2wgICAlcjE0LDAwMDAwMDAwZWU4MjRh
YjAKWyAxMzc2LjMyOTk1M10gICAgICAgICAgICAwMDAwMDAwMGVlODI3N2JjOiBhN2Y0ZmMzNiAg
ICAgICAgICAgIGJyYyAgICAgMTUsMDAwMDAwMDBlZTgyNzAyOApbIDEzNzYuMzI5OTUzXSAgICAg
ICAgICAgIzAwMDAwMDAwZWU4Mjc3YzA6IGE1MjdmZmY4ICAgICAgICAgICAgbmlsbCAgICAlcjIs
NjU1MjgKWyAxMzc2LjMyOTk1M10gICAgICAgICAgID4wMDAwMDAwMGVlODI3N2M0OiA1ODMwMjAz
NCAgICAgICAgICAgIGwgICAgICAgJXIzLDUyKCVyMikKWyAxMzc2LjMyOTk1M10gICAgICAgICAg
ICAwMDAwMDAwMGVlODI3N2M4OiBlYzM4ZmM2NjAwN2UgICAgICAgIGNpaiAgICAgJXIzLDAsOCww
MDAwMDAwMGVlODI3MDk0ClsgMTM3Ni4zMjk5NTNdICAgICAgICAgICAgMDAwMDAwMDBlZTgyNzdj
ZTogNTgyMDIwMTAgICAgICAgICAgICBsICAgICAgICVyMiwxNiglcjIpClsgMTM3Ni4zMjk5NTNd
ICAgICAgICAgICAgMDAwMDAwMDBlZTgyNzdkMjogYjkxNDAwMjIgICAgICAgICAgICBsZ2ZyICAg
ICVyMiwlcjIKWyAxMzc2LjMyOTk1M10gICAgICAgICAgICAwMDAwMDAwMGVlODI3N2Q2OiBjMGU1
ZmY4ZWNkZmQgICAgICAgIGJyYXNsICAgJXIxNCwwMDAwMDAwMGVkYTAxM2QwClsgMTM3Ni4zMjk5
NjldIENhbGwgVHJhY2U6ClsgMTM3Ni4zMjk5NzFdICBbPDAwMDAwMDAwZWU4Mjc3YzQ+XSBfX211
dGV4X2xvY2srMHg5ZmMvMHhmYTggClsgMTM3Ni4zMjk5NzRdIChbPDAwMDAwMDAwZWU4MjczOTY+
XSBfX211dGV4X2xvY2srMHg1Y2UvMHhmYTgpClsgMTM3Ni4zMjk5NzddICBbPDAwMDAwMDAwZWU4
MjdkYTI+XSBtdXRleF9sb2NrX25lc3RlZCsweDMyLzB4NDAgClsgMTM3Ni4zMjk5ODBdICBbPDAw
MDAwM2ZmN2ZiY2RmZDg+XSBtbHg1X2NvcmVfdXBsaW5rX25ldGRldl9zZXQrMHgzOC8weDYwIFtt
bHg1X2NvcmVdIApbIDEzNzYuMzMwMDMyXSAgWzwwMDAwMDNmZjdmYzExMDBjPl0gbWx4NWVfcmVt
b3ZlKzB4M2MvMHhhMCBbbWx4NV9jb3JlXSAKWyAxMzc2LjMzMDA4NV0gIFs8MDAwMDAwMDBlZTQy
ZmE3Yz5dIGRldmljZV9yZWxlYXNlX2RyaXZlcl9pbnRlcm5hbCsweDFjNC8weDI3MCAKWyAxMzc2
LjMzMDA4OF0gIFs8MDAwMDAwMDBlZTQyZDc4OD5dIGJ1c19yZW1vdmVfZGV2aWNlKzB4MTAwLzB4
MTg4IApbIDEzNzYuMzMwMDkwXSAgWzwwMDAwMDAwMGVlNDI3MjRlPl0gZGV2aWNlX2RlbCsweDE4
Ni8weDNiOCAKWyAxMzc2LjMzMDA5M10gIFs8MDAwMDAzZmY3ZmJmNjEzND5dIG1seDVfZGV0YWNo
X2RldmljZSsweGFjLzB4MTEwIFttbHg1X2NvcmVdIApbIDEzNzYuMzMwMTQzXSAgWzwwMDAwMDNm
ZjdmYmNmODEyPl0gbWx4NV91bmxvYWRfb25lX2RldmxfbG9ja2VkKzB4NTIvMHhjOCBbbWx4NV9j
b3JlXSAKWyAxMzc2LjMzMDE5NV0gIFs8MDAwMDAzZmY3ZmM3NzdlOD5dIG1seDVfaGVhbHRoX3Ry
eV9yZWNvdmVyKzB4MTY4LzB4MjQwIFttbHg1X2NvcmVdIApbIDEzNzYuMzMwMjQ2XSAgWzwwMDAw
MDAwMGVlNzJiOWQyPl0gZGV2bGlua19oZWFsdGhfcmVwb3J0ZXJfcmVjb3ZlcisweDNhLzB4OTgg
ClsgMTM3Ni4zMzAyNDldICBbPDAwMDAwMDAwZWU3MmJiM2M+XSBkZXZsaW5rX2hlYWx0aF9yZXBv
cnQrMHgxMGMvMHgzMDAgClsgMTM3Ni4zMzAyNTFdICBbPDAwMDAwM2ZmN2ZiZGQwYWM+XSBtbHg1
X2Z3X2ZhdGFsX3JlcG9ydGVyX2Vycl93b3JrKzB4YzQvMHgxZDggW21seDVfY29yZV0gClsgMTM3
Ni4zMzAzMDNdICBbPDAwMDAwMDAwZWRhNmI5MzQ+XSBwcm9jZXNzX29uZV93b3JrKzB4MzBjLzB4
Njg4IApbIDEzNzYuMzMwMzA1XSAgWzwwMDAwMDAwMGVkYTZiZDEyPl0gd29ya2VyX3RocmVhZCsw
eDYyLzB4NDM4IApbIDEzNzYuMzMwMzA4XSAgWzwwMDAwMDAwMGVkYTc3NDAwPl0ga3RocmVhZCsw
eDEzOC8weDE1MCAKWyAxMzc2LjMzMDMxMV0gIFs8MDAwMDAwMDBlZDllYjg5ND5dIF9fcmV0X2Zy
b21fZm9yaysweDNjLzB4NTggClsgMTM3Ni4zMzAzMTRdICBbPDAwMDAwMDAwZWU4MzA5ZGE+XSBy
ZXRfZnJvbV9mb3JrKzB4YS8weDQwIApbIDEzNzYuMzMwMzE2XSBJTkZPOiBsb2NrZGVwIGlzIHR1
cm5lZCBvZmYuClsgMTM3Ni4zMzAzMTddIExhc3QgQnJlYWtpbmctRXZlbnQtQWRkcmVzczoKWyAx
Mzc2LjMzMDMxOV0gIFs8MDAwMDAwMDBlZTgyNmY5Yz5dIF9fbXV0ZXhfbG9jaysweDFkNC8weGZh
OApbIDEzNzYuMzMwMzIzXSBLZXJuZWwgcGFuaWMgLSBub3Qgc3luY2luZzogRmF0YWwgZXhjZXB0
aW9uOiBwYW5pY19vbl9vb3BzCg==


--=-eYGpCmT4UMD9DC6zFMZP--

