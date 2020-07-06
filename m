Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D26A215B94
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 18:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729534AbgGFQNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 12:13:02 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43108 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729293AbgGFQNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 12:13:02 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 066GCJ8i066857;
        Mon, 6 Jul 2020 12:12:58 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 322n2rhsvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 12:12:57 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 066Fu6lB012044;
        Mon, 6 Jul 2020 16:12:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 322hd7s8u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jul 2020 16:12:55 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 066GCo6W12714360
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jul 2020 16:12:50 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1352A4053;
        Mon,  6 Jul 2020 16:12:50 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CA89A4040;
        Mon,  6 Jul 2020 16:12:50 +0000 (GMT)
Received: from oc5500677777.ibm.com (unknown [9.145.60.46])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jul 2020 16:12:50 +0000 (GMT)
To:     Shay Drory <shayd@mellanox.com>
From:   Niklas Schnelle <schnelle@linux.ibm.com>
Subject: mlx5 hot unplug regression on z/VM
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Stefan Raspl <raspl@de.ibm.com>
Message-ID: <0bc1a170-a643-a9d4-4b3b-2bdd2bb63759@linux.ibm.com>
Date:   Mon, 6 Jul 2020 18:12:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------65C033B7CF615B77F5A99BBA"
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-06_12:2020-07-06,2020-07-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1011 adultscore=0 phishscore=0 priorityscore=1501
 cotscore=-2147483648 impostorscore=0 bulkscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007060118
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------65C033B7CF615B77F5A99BBA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi Mr. Drory, Hi Netdev List,

I'm the PCI Subsystem maintainer for Linux on IBM Z and since v5.8-rc1
we've been seeing a regression with hot unplug of ConnectX-4 VFs
from z/VM guests. In -rc1 this still looked like a simple issue and
I wrote the following mail:
https://lkml.org/lkml/2020/6/12/376
sadly since I think -rc2 I've not been able to get this working consistently
anymore (it did work consistently with the change described above on -rc1).
In his answer Saeed Mahameed pointed me to your commits as dealing with
similar issues so I wanted to get some input on how to debug this
further.

The commands I used to test this are as follows (on a z/VM guest running
vanilla debug_defconfig v5.8-rc4 installed on Fedora 31) and you find the resulting
dmesg attached to this mail:

# vmcp q pcif  // query for available PCI devices
# vmcp attach pcif <FID> to \* // where <FID> is one of the ones listed by the above command
# vmcp detach pcif <FID> // This does a hot unplug and is where things start going wrong

I guess you don't have access to hardware but I'll be happy to assist
as good as I can since digging on my own I sadly really don't know
enough about the mlx5_core driver to make more progress.

Best regards,
Niklas Schnelle

--------------65C033B7CF615B77F5A99BBA
Content-Type: text/plain; charset=UTF-8;
 name="dmesg_mlx5_detach_zvm.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="dmesg_mlx5_detach_zvm.txt"

WyAgIDcwLjc3MzQ3OF0gSVB2NjogQUREUkNPTkYoTkVUREVWX0NIQU5HRSk6IGVuczUxNG5w
MDogbGluayBiZWNvbWVzIHJlYWR5ClsgICA3MC44NTg2ODhdIFJQQzogUmVnaXN0ZXJlZCBu
YW1lZCBVTklYIHNvY2tldCB0cmFuc3BvcnQgbW9kdWxlLgpbICAgNzAuODU4NzA5XSBSUEM6
IFJlZ2lzdGVyZWQgdWRwIHRyYW5zcG9ydCBtb2R1bGUuClsgICA3MC44NTg3MTRdIFJQQzog
UmVnaXN0ZXJlZCB0Y3AgdHJhbnNwb3J0IG1vZHVsZS4KWyAgIDcwLjg1ODcxOV0gUlBDOiBS
ZWdpc3RlcmVkIHRjcCBORlN2NC4xIGJhY2tjaGFubmVsIHRyYW5zcG9ydCBtb2R1bGUuClsg
ICA3MC45MjI2ODldIFJQQzogUmVnaXN0ZXJlZCByZG1hIHRyYW5zcG9ydCBtb2R1bGUuClsg
ICA3MC45MjI3MjRdIFJQQzogUmVnaXN0ZXJlZCByZG1hIGJhY2tjaGFubmVsIHRyYW5zcG9y
dCBtb2R1bGUuClsgICA5Mi4wMjI3MDVdIG1seDVfY29yZSAwMDAwOjAwOjAwLjA6IHBvbGxf
aGVhbHRoOjcwMjoocGlkIDApOiBGYXRhbCBlcnJvciAxIGRldGVjdGVkClsgICA5Mi4wMjI5
OTVdIG1seDVfY29yZSAwMDAwOjAwOjAwLjA6IHByaW50X2hlYWx0aF9pbmZvOjM4MDoocGlk
IDApOiBhc3NlcnRfdmFyWzBdIDB4ZmZmZmZmZmYKWyAgIDkyLjAyMzAwMl0gbWx4NV9jb3Jl
IDAwMDA6MDA6MDAuMDogcHJpbnRfaGVhbHRoX2luZm86MzgwOihwaWQgMCk6IGFzc2VydF92
YXJbMV0gMHhmZmZmZmZmZgpbICAgOTIuMDIzMDA5XSBtbHg1X2NvcmUgMDAwMDowMDowMC4w
OiBwcmludF9oZWFsdGhfaW5mbzozODA6KHBpZCAwKTogYXNzZXJ0X3ZhclsyXSAweGZmZmZm
ZmZmClsgICA5Mi4wMjMwMTZdIG1seDVfY29yZSAwMDAwOjAwOjAwLjA6IHByaW50X2hlYWx0
aF9pbmZvOjM4MDoocGlkIDApOiBhc3NlcnRfdmFyWzNdIDB4ZmZmZmZmZmYKWyAgIDkyLjAy
MzAyM10gbWx4NV9jb3JlIDAwMDA6MDA6MDAuMDogcHJpbnRfaGVhbHRoX2luZm86MzgwOihw
aWQgMCk6IGFzc2VydF92YXJbNF0gMHhmZmZmZmZmZgpbICAgOTIuMDIzMDMwXSBtbHg1X2Nv
cmUgMDAwMDowMDowMC4wOiBwcmludF9oZWFsdGhfaW5mbzozODM6KHBpZCAwKTogYXNzZXJ0
X2V4aXRfcHRyIDB4ZmZmZmZmZmYKWyAgIDkyLjAyMzAzOF0gbWx4NV9jb3JlIDAwMDA6MDA6
MDAuMDogcHJpbnRfaGVhbHRoX2luZm86Mzg1OihwaWQgMCk6IGFzc2VydF9jYWxscmEgMHhm
ZmZmZmZmZgpbICAgOTIuMDIzMDQ4XSBtbHg1X2NvcmUgMDAwMDowMDowMC4wOiBwcmludF9o
ZWFsdGhfaW5mbzozODg6KHBpZCAwKTogZndfdmVyIDY1NTM1LjY1NTM1LjY1NTM1ClsgICA5
Mi4wMjMwNTZdIG1seDVfY29yZSAwMDAwOjAwOjAwLjA6IHByaW50X2hlYWx0aF9pbmZvOjM4
OToocGlkIDApOiBod19pZCAweGZmZmZmZmZmClsgICA5Mi4wMjMwNjVdIG1seDVfY29yZSAw
MDAwOjAwOjAwLjA6IHByaW50X2hlYWx0aF9pbmZvOjM5MDoocGlkIDApOiBpcmlzY19pbmRl
eCAyNTUKWyAgIDkyLjAyMzA3NV0gbWx4NV9jb3JlIDAwMDA6MDA6MDAuMDogcHJpbnRfaGVh
bHRoX2luZm86MzkxOihwaWQgMCk6IHN5bmQgMHhmZjogdW5yZWNvZ25pemVkIGVycm9yClsg
ICA5Mi4wMjMxMjldIG1seDVfY29yZSAwMDAwOjAwOjAwLjA6IHByaW50X2hlYWx0aF9pbmZv
OjM5MzoocGlkIDApOiBleHRfc3luZCAweGZmZmYKWyAgIDkyLjAyMzEzNl0gbWx4NV9jb3Jl
IDAwMDA6MDA6MDAuMDogcHJpbnRfaGVhbHRoX2luZm86Mzk1OihwaWQgMCk6IHJhdyBmd192
ZXIgMHhmZmZmZmZmZgpbICAgOTIuMDIzODIzXSBjcndfaW5mbyA6IENSVyByZXBvcnRzIHNs
Y3Q9MCwgb2Zsdz0wLCBjaG49MCwgcnNjPUIsIGFuYz0wLCBlcmM9MCwgcnNpZD0wClsgICA5
Mi4wMjM4NTldIG1seDVfY29yZSAwMDAwOjAwOjAwLjA6IFBNRSMgZGlzYWJsZWQKWyAgMTAy
Ljc1MTIyN10gbWx4NV9jb3JlIDAwMDA6MDA6MDAuMDogcG9sbF9oZWFsdGg6NzE3OihwaWQg
MTApOiBkZXZpY2UncyBoZWFsdGggY29tcHJvbWlzZWQgLSByZWFjaGVkIG1pc3MgY291bnQK
WyAgMTAyLjc1MTI0N10gbWx4NV9jb3JlIDAwMDA6MDA6MDAuMDogcHJpbnRfaGVhbHRoX2lu
Zm86MzgwOihwaWQgMTApOiBhc3NlcnRfdmFyWzBdIDB4ZmZmZmZmZmYKWyAgMTAyLjc1MTI1
M10gbWx4NV9jb3JlIDAwMDA6MDA6MDAuMDogcHJpbnRfaGVhbHRoX2luZm86MzgwOihwaWQg
MTApOiBhc3NlcnRfdmFyWzFdIDB4ZmZmZmZmZmYKWyAgMTAyLjc1MTI2MF0gbWx4NV9jb3Jl
IDAwMDA6MDA6MDAuMDogcHJpbnRfaGVhbHRoX2luZm86MzgwOihwaWQgMTApOiBhc3NlcnRf
dmFyWzJdIDB4ZmZmZmZmZmYKWyAgMTAyLjc1MTI2Nl0gbWx4NV9jb3JlIDAwMDA6MDA6MDAu
MDogcHJpbnRfaGVhbHRoX2luZm86MzgwOihwaWQgMTApOiBhc3NlcnRfdmFyWzNdIDB4ZmZm
ZmZmZmYKWyAgMTAyLjc1MTI3M10gbWx4NV9jb3JlIDAwMDA6MDA6MDAuMDogcHJpbnRfaGVh
bHRoX2luZm86MzgwOihwaWQgMTApOiBhc3NlcnRfdmFyWzRdIDB4ZmZmZmZmZmYKWyAgMTAy
Ljc1MTI4MF0gbWx4NV9jb3JlIDAwMDA6MDA6MDAuMDogcHJpbnRfaGVhbHRoX2luZm86Mzgz
OihwaWQgMTApOiBhc3NlcnRfZXhpdF9wdHIgMHhmZmZmZmZmZgpbICAxMDIuNzUxMjg3XSBt
bHg1X2NvcmUgMDAwMDowMDowMC4wOiBwcmludF9oZWFsdGhfaW5mbzozODU6KHBpZCAxMCk6
IGFzc2VydF9jYWxscmEgMHhmZmZmZmZmZgpbICAxMDIuNzUxMjk2XSBtbHg1X2NvcmUgMDAw
MDowMDowMC4wOiBwcmludF9oZWFsdGhfaW5mbzozODg6KHBpZCAxMCk6IGZ3X3ZlciA2NTUz
NS42NTUzNS42NTUzNQpbICAxMDIuNzUxMzAzXSBtbHg1X2NvcmUgMDAwMDowMDowMC4wOiBw
cmludF9oZWFsdGhfaW5mbzozODk6KHBpZCAxMCk6IGh3X2lkIDB4ZmZmZmZmZmYKWyAgMTAy
Ljc1MTMxMV0gbWx4NV9jb3JlIDAwMDA6MDA6MDAuMDogcHJpbnRfaGVhbHRoX2luZm86Mzkw
OihwaWQgMTApOiBpcmlzY19pbmRleCAyNTUKWyAgMTAyLjc1MTQwMV0gbWx4NV9jb3JlIDAw
MDA6MDA6MDAuMDogcHJpbnRfaGVhbHRoX2luZm86MzkxOihwaWQgMTApOiBzeW5kIDB4ZmY6
IHVucmVjb2duaXplZCBlcnJvcgpbICAxMDIuNzUxNDA3XSBtbHg1X2NvcmUgMDAwMDowMDow
MC4wOiBwcmludF9oZWFsdGhfaW5mbzozOTM6KHBpZCAxMCk6IGV4dF9zeW5kIDB4ZmZmZgpb
ICAxMDIuNzUxNDEzXSBtbHg1X2NvcmUgMDAwMDowMDowMC4wOiBwcmludF9oZWFsdGhfaW5m
bzozOTU6KHBpZCAxMCk6IHJhdyBmd192ZXIgMHhmZmZmZmZmZgpbICAxNTcuMDY4ODc2XSBt
bHg1X2NvcmUgMDAwMDowMDowMC4wOiB3YWl0X2Z1bmM6MTAwODoocGlkIDc0KTogMlJTVF9R
UCgweDUwYSkgdGltZW91dC4gV2lsbCBjYXVzZSBhIGxlYWsgb2YgYSBjb21tYW5kIHJlc291
cmNlClsgIDE1Ny4wNjkxNDVdIGluZmluaWJhbmQgbWx4NV8wOiBkZXN0cm95X3FwX2NvbW1v
bjoyMzY3OihwaWQgNzQpOiBtbHg1X2liOiBtb2RpZnkgUVAgMHgwMDA3MjQgdG8gUkVTRVQg
ZmFpbGVkClsgIDE3Ny41NDg3MDFdIG1seDVfY29yZSAwMDAwOjAwOjAwLjA6IHdhaXRfZnVu
YzoxMDA4OihwaWQgOCk6IFFVRVJZX1ZQT1JUX0NPVU5URVIoMHg3NzApIHRpbWVvdXQuIFdp
bGwgY2F1c2UgYSBsZWFrIG9mIGEgY29tbWFuZCByZXNvdXJjZQpbICAyMTguNTA4MzgyXSBt
bHg1X2NvcmUgMDAwMDowMDowMC4wOiB3YWl0X2Z1bmM6MTAwODoocGlkIDc0KTogREVTVFJP
WV9RUCgweDUwMSkgdGltZW91dC4gV2lsbCBjYXVzZSBhIGxlYWsgb2YgYSBjb21tYW5kIHJl
c291cmNlClsgIDIzOC45ODgyMjldIG1seDVfY29yZSAwMDAwOjAwOjAwLjA6IHdhaXRfZnVu
YzoxMDA4OihwaWQgOCk6IFFVRVJZX1FfQ09VTlRFUigweDc3MykgdGltZW91dC4gV2lsbCBj
YXVzZSBhIGxlYWsgb2YgYSBjb21tYW5kIHJlc291cmNlClsgIDI0NC4xMDgyMTFdIElORk86
IHRhc2sgTmV0d29ya01hbmFnZXI6NjgxIGJsb2NrZWQgZm9yIG1vcmUgdGhhbiAxMjIgc2Vj
b25kcy4KWyAgMjQ0LjEwODQ0Nl0gICAgICAgTm90IHRhaW50ZWQgNS44LjAtcmM0ICMxClsg
IDI0NC4xMDg0NTBdICJlY2hvIDAgPiAvcHJvYy9zeXMva2VybmVsL2h1bmdfdGFza190aW1l
b3V0X3NlY3MiIGRpc2FibGVzIHRoaXMgbWVzc2FnZS4KWyAgMjQ0LjEwODQ1Nl0gTmV0d29y
a01hbmFnZXIgIEQgOTI0MCAgIDY4MSAgICAgIDEgMHgwMDAwMDAwMApbICAyNDQuMTA4NDY3
XSBDYWxsIFRyYWNlOgpbICAyNDQuMTA4NDc5XSAgWzwwMDAwMDAwMGI5MjI1YzQ2Pl0gX19z
Y2hlZHVsZSsweDJkNi8weDVhOApbICAyNDQuMTA4NDg1XSAgWzwwMDAwMDAwMGI5MjI1Zjcy
Pl0gc2NoZWR1bGUrMHg1YS8weDEzMApbICAyNDQuMTA4NDkxXSAgWzwwMDAwMDAwMGI5MjI2
NzA0Pl0gc2NoZWR1bGVfcHJlZW1wdF9kaXNhYmxlZCsweDJjLzB4NDgKWyAgMjQ0LjEwODQ5
N10gIFs8MDAwMDAwMDBiOTIyODljMj5dIF9fbXV0ZXhfbG9jaysweDM3Mi8weDk2MApbICAy
NDQuMTA4NTAzXSAgWzwwMDAwMDAwMGI5MjI4ZmUyPl0gbXV0ZXhfbG9ja19uZXN0ZWQrMHgz
Mi8weDQwClsgIDI0NC4xMDg1NjVdICBbPDAwMDAwM2ZmODAyMGNiYjI+XSBtbHg1ZV94ZHAr
MHg2Mi8weGQwIFttbHg1X2NvcmVdClsgIDI0NC4xMDg1NzNdICBbPDAwMDAwMDAwYjhmYmNj
MjQ+XSBfX2Rldl94ZHBfcXVlcnkucGFydC4wKzB4MzQvMHg3MApbICAyNDQuMTA4NTgyXSAg
WzwwMDAwMDAwMGI4ZmUxZDNjPl0gcnRubF94ZHBfZmlsbCsweDg0LzB4MjU4ClsgIDI0NC4x
MDg1ODhdICBbPDAwMDAwMDAwYjhmZTVmNTQ+XSBydG5sX2ZpbGxfaWZpbmZvKzB4NmE0LzB4
ZDY4ClsgIDI0NC4xMDg1OTVdICBbPDAwMDAwMDAwYjhmZTZmM2U+XSBydG5sX2dldGxpbmsr
MHgyNjYvMHgzZTgKWyAgMjQ0LjEwODYwMl0gIFs8MDAwMDAwMDBiOGZlMmNjZT5dIHJ0bmV0
bGlua19yY3ZfbXNnKzB4MThlLzB4NGIwClsgIDI0NC4xMDg2MThdICBbPDAwMDAwMDAwYjkw
NDkxM2U+XSBuZXRsaW5rX3Jjdl9za2IrMHg0ZS8weGY4ClsgIDI0NC4xMDg2MjNdICBbPDAw
MDAwMDAwYjkwNDg4YjI+XSBuZXRsaW5rX3VuaWNhc3QrMHgxOGEvMHgyNjgKWyAgMjQ0LjEw
ODYyN10gIFs8MDAwMDAwMDBiOTA0OGNmNj5dIG5ldGxpbmtfc2VuZG1zZysweDM2Ni8weDQ0
OApbICAyNDQuMTA4NjM0XSAgWzwwMDAwMDAwMGI4Zjk0YjRjPl0gc29ja19zZW5kbXNnKzB4
NjQvMHg3OApbICAyNDQuMTA4NjM4XSAgWzwwMDAwMDAwMGI4Zjk2NWQ2Pl0gX19fX3N5c19z
ZW5kbXNnKzB4MWY2LzB4MjQwClsgIDI0NC4xMDg2NDNdICBbPDAwMDAwMDAwYjhmOThjMDQ+
XSBfX19zeXNfc2VuZG1zZysweDc0LzB4YTgKWyAgMjQ0LjEwODY0OF0gIFs8MDAwMDAwMDBi
OGY5OGNmND5dIF9fc3lzX3NlbmRtc2crMHg2NC8weGE4ClsgIDI0NC4xMDg2NTJdICBbPDAw
MDAwMDAwYjhmOTk1YjQ+XSBfX2RvX3N5c19zb2NrZXRjYWxsKzB4MmRjLzB4MzQwClsgIDI0
NC4xMDg2NzZdICBbPDAwMDAwMDAwYjkyMmU2MTg+XSBzeXN0ZW1fY2FsbCsweGRjLzB4MmMw
ClsgIDI0NC4xMDg2ODJdIDIgbG9ja3MgaGVsZCBieSBOZXR3b3JrTWFuYWdlci82ODE6Clsg
IDI0NC4xMDg2ODhdICAjMDogMDAwMDAwMDBiOTcyY2FlOCAocnRubF9tdXRleCl7Ky4rLn0t
ezM6M30sIGF0OiBydG5ldGxpbmtfcmN2X21zZysweDE2MC8weDRiMApbICAyNDQuMTA4Njk4
XSAgIzE6IDAwMDAwMDAwZDMxMDNiODAgKCZwcml2LT5zdGF0ZV9sb2NrKXsrLisufS17Mzoz
fSwgYXQ6IG1seDVlX3hkcCsweDYyLzB4ZDAgW21seDVfY29yZV0KWyAgMjQ0LjEwODczMV0K
ICAgICAgICAgICAgICAgU2hvd2luZyBhbGwgbG9ja3MgaGVsZCBpbiB0aGUgc3lzdGVtOgpb
ICAyNDQuMTA4NzQzXSAzIGxvY2tzIGhlbGQgYnkga3dvcmtlci91MTI4OjAvODoKWyAgMjQ0
LjEwODc0OV0gICMwOiAwMDAwMDAwMGQyZjIxMTQ4ICgod3FfY29tcGxldGlvbiltbHg1ZSl7
Ky4rLn0tezA6MH0sIGF0OiBwcm9jZXNzX29uZV93b3JrKzB4MWRjLzB4NDc4ClsgIDI0NC4x
MDg3NjRdICAjMTogMDAwMDAzZTAwMDA0N2UxOCAoKHdvcmtfY29tcGxldGlvbikoJnByaXYt
PnVwZGF0ZV9zdGF0c193b3JrKSl7Ky4rLn0tezA6MH0sIGF0OiBwcm9jZXNzX29uZV93b3Jr
KzB4MWRjLzB4NDc4ClsgIDI0NC4xMDg3NzFdICAjMjogMDAwMDAwMDBkMzEwM2I4MCAoJnBy
aXYtPnN0YXRlX2xvY2speysuKy59LXszOjN9LCBhdDogbWx4NWVfdXBkYXRlX3N0YXRzX3dv
cmsrMHgzNC8weDY4IFttbHg1X2NvcmVdClsgIDI0NC4xMDg3OTRdIDMgbG9ja3MgaGVsZCBi
eSBrd29ya2VyLzE6MC8xNzoKWyAgMjQ0LjEwODc5OF0gICMwOiAwMDAwMDAwMGU5OTIyOTQ4
ICgod3FfY29tcGxldGlvbilpcHY2X2FkZHJjb25mKXsrLisufS17MDowfSwgYXQ6IHByb2Nl
c3Nfb25lX3dvcmsrMHgxZGMvMHg0NzgKWyAgMjQ0LjEwODgwNV0gICMxOiAwMDAwMDNlMDAw
MjhmZTE4ICgoYWRkcl9jaGtfd29yaykud29yayl7Ky4rLn0tezA6MH0sIGF0OiBwcm9jZXNz
X29uZV93b3JrKzB4MWRjLzB4NDc4ClsgIDI0NC4xMDg4MTNdICAjMjogMDAwMDAwMDBiOTcy
Y2FlOCAocnRubF9tdXRleCl7Ky4rLn0tezM6M30sIGF0OiBhZGRyY29uZl92ZXJpZnlfd29y
aysweDIyLzB4MzgKWyAgMjQ0LjEwODgyMl0gMSBsb2NrIGhlbGQgYnkga2h1bmd0YXNrZC8y
OToKWyAgMjQ0LjEwODgyNl0gICMwOiAwMDAwMDAwMGI5NjlhOTkwIChyY3VfcmVhZF9sb2Nr
KXsuLi4ufS17MToyfSwgYXQ6IHJjdV9sb2NrX2FjcXVpcmUuY29uc3Rwcm9wLjArMHgwLzB4
NTAKWyAgMjQ0LjEwODgzN10gNiBsb2NrcyBoZWxkIGJ5IGttY2hlY2svNzQ6ClsgIDI0NC4x
MDg4NDFdICAjMDogMDAwMDAwMDBiOTczOWU0OCAoY3J3X2hhbmRsZXJfbXV0ZXgpeysuKy59
LXszOjN9LCBhdDogY3J3X2NvbGxlY3RfaW5mbysweDI1MC8weDM1MApbICAyNDQuMTA4ODQ5
XSAgIzE6IDAwMDAwMDAwYjk3MTk2NjggKHBjaV9yZXNjYW5fcmVtb3ZlX2xvY2speysuKy59
LXszOjN9LCBhdDogcGNpX3N0b3BfYW5kX3JlbW92ZV9idXNfZGV2aWNlX2xvY2tlZCsweDI2
LzB4NDgKWyAgMjQ0LjEwODg1OF0gICMyOiAwMDAwMDAwMGQ4MTY5MjM4ICgmZGV2LT5tdXRl
eCl7Li4uLn0tezM6M30sIGF0OiBkZXZpY2VfcmVsZWFzZV9kcml2ZXIrMHgzMi8weDUwClsg
IDI0NC4xMDg4NjZdICAjMzogMDAwMDAwMDBkNDI2Y2JiOCAoJmRldi0+aW50Zl9zdGF0ZV9t
dXRleCl7Ky4rLn0tezM6M30sIGF0OiBtbHg1X3VubG9hZF9vbmUrMHgzOC8weDE0MCBbbWx4
NV9jb3JlXQpbICAyNDQuMTA4ODg3XSAgIzQ6IDAwMDAwM2ZmODAyNGEyODAgKG1seDVfaW50
Zl9tdXRleCl7Ky4rLn0tezM6M30sIGF0OiBtbHg1X3VucmVnaXN0ZXJfZGV2aWNlKzB4MzYv
MHhjOCBbbWx4NV9jb3JlXQpbICAyNDQuMTA4OTA4XSAgIzU6IDAwMDAwMDAwY2Y0Zjg2NTAg
KCZkZXZpY2UtPnVucmVnaXN0cmF0aW9uX2xvY2speysuKy59LXszOjN9LCBhdDogX19pYl91
bnJlZ2lzdGVyX2RldmljZSsweDMyLzB4YzggW2liX2NvcmVdClsgIDI0NC4xMDg5NTddIDIg
bG9ja3MgaGVsZCBieSBOZXR3b3JrTWFuYWdlci82ODE6ClsgIDI0NC4xMDg5NjFdICAjMDog
MDAwMDAwMDBiOTcyY2FlOCAocnRubF9tdXRleCl7Ky4rLn0tezM6M30sIGF0OiBydG5ldGxp
bmtfcmN2X21zZysweDE2MC8weDRiMApbICAyNDQuMTA4OTczXSAgIzE6IDAwMDAwMDAwZDMx
MDNiODAgKCZwcml2LT5zdGF0ZV9sb2NrKXsrLisufS17MzozfSwgYXQ6IG1seDVlX3hkcCsw
eDYyLzB4ZDAgW21seDVfY29yZV0KCg==
--------------65C033B7CF615B77F5A99BBA--

