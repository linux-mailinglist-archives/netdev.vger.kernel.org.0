Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6649B312D3E
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 10:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbhBHJ1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 04:27:37 -0500
Received: from esa1.mentor.iphmx.com ([68.232.129.153]:40810 "EHLO
        esa1.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbhBHJZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 04:25:30 -0500
IronPort-SDR: hB1Nvw8g4LQrxTCq/pK8/XsC+hJJ3/WH491QQc2C+afwk9h0mm0rDbBcnmn/KQZSsOZw7r4tyW
 l62a1B0rvKpz4I51ct4IblpMHGGqJbYmEVAypr2VgUK6CvVNzzyGAHgGAd7czJI+b3yK9ChzMP
 cuzCDUw5qTNOYfzl6eI5stgnYRP8LBwttWKjoyjCpqkQYIrc/Dq2lDqaoDye8J/M7cYwrnzNvT
 tHBxRvuKPp/UK2XGliFFVoimJiOMD5vwffjj5lBRzE5X/FOCfq11xT7nAl0+itfsfc/fsHhXs0
 wl8=
X-IronPort-AV: E=Sophos;i="5.81,161,1610438400"; 
   d="scan'208,223";a="60168842"
Received: from orw-gwy-01-in.mentorg.com ([192.94.38.165])
  by esa1.mentor.iphmx.com with ESMTP; 08 Feb 2021 01:24:17 -0800
IronPort-SDR: YyXUU93KmTI2N2Up/kJyjsKZcvO36P3q4bCEdg/cj2VXg5/kQNgnhV+Dc6+ncsmoNjrde9Hnk7
 N08aPXP9x2JH9zv9SBGwqZ0J7wrx+DcKnkbzKHQ9sitU3CXJ6ew+0vdnFW6uX18LkabMgEuzKd
 7TTmQj7q0moSQAL4PwTUINr5xBjZre9jbNix1VuE1BXyr8jzhcsmHUe+wmXiQoKlybfxANnLjN
 ppn5GvLlLmOSaFl1pn+q62be1Ckm4z686besYcsQVjUetRYREy43Hl9KWTFoTnYSWEbkB/3pJ+
 7xY=
From:   "Schmid, Carsten" <Carsten_Schmid@mentor.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "weiwan@google.com" <weiwan@google.com>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "jesse@mbuki-mvuki.org" <jesse@mbuki-mvuki.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: AW: Where is this patch buried?
Thread-Topic: Where is this patch buried?
Thread-Index: AQHW/fIkZ019VAXYJE+A3ji1EQtU3KpN8pgAgAAFj1U=
Date:   Mon, 8 Feb 2021 09:24:11 +0000
Message-ID: <1612776251858.30522@mentor.com>
References: <7953a4158fd14aabbcfbad8365231961@SVR-IES-MBX-03.mgc.mentorg.com>,<YCD6/OByXFRyuR71@kroah.com>
In-Reply-To: <YCD6/OByXFRyuR71@kroah.com>
Accept-Language: de-DE, en-IE, en-US
Content-Language: de-DE
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [137.202.0.90]
Content-Type: multipart/mixed; boundary="_002_161277625185830522mentorcom_"
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_161277625185830522mentorcom_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

>> Hi Greg,
>>
>> in kernel 4.14 i have seen a NULL pointer deref in
>> [65064.613465] RIP: 0010:ip_route_output_key_hash_rcu+0x755/0x850
>> (i have a core dump and detailed analysis)
>>
>> That looks like this patch could have prevented it:
>>
>> https://www.spinics.net/lists/stable-commits/msg133055.html
>>
>> this one was queued for 4.14, but i can't find it in git tree?
>> Any idea who/what buried this one?
>>
>> In 4.19 it is present.
>>
>> Because our customer uses 4.14 (going to 4.14.212 in a few days) i kindl=
y want to
>> ask why this patch hasn't entered 4.14.
>
> Because it breaks the build?  Try it yourself and see what happens :)

yep. rt_add_uncached_list is implemented _after_ the call :-(

>
> I will gladly take a working backport if you can submit it.
>
Please find it attached - i needed to move rt_add_uncached_list before
the rt_cache_route, nothing else changed.
This is for 4.14 only, as other kernels do have this patch.

I can't reproduce the crash at will, but at least i could compile and flash=
 it on my target.
And the target comes up .. hopefully the testing in other/newer kernels
done by the developers of the patch is also valid for 4.14.

> thanks,
>
> greg k-h

Thanks,
Carsten
-----------------
Mentor Graphics (Deutschland) GmbH, Arnulfstrasse 201, 80634 M=FCnchen Regi=
stergericht M=FCnchen HRB 106955, Gesch=E4ftsf=FChrer: Thomas Heurung, Fran=
k Th=FCrauf

--_002_161277625185830522mentorcom_
Content-Type: text/x-patch;
	name="0001-ipv4-fix-race-condition-between-route-lookup-and-inv.patch"
Content-Description: 0001-ipv4-fix-race-condition-between-route-lookup-and-inv.patch
Content-Disposition: attachment;
	filename="0001-ipv4-fix-race-condition-between-route-lookup-and-inv.patch";
	size=4140; creation-date="Mon, 08 Feb 2021 09:13:00 GMT";
	modification-date="Mon, 08 Feb 2021 09:13:00 GMT"
Content-Transfer-Encoding: base64

RnJvbSA2NjdmODE0MjA3ZmMwYWE5YjNlNjIwYzczM2QxNzU0ZWM1MjJjNDQ3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXZWkgV2FuZyA8d2Vpd2FuQGdvb2dsZS5jb20+CkRhdGU6IFdl
ZCwgMTYgT2N0IDIwMTkgMTI6MDM6MTUgLTA3MDAKU3ViamVjdDogW1BBVENIXSBpcHY0OiBmaXgg
cmFjZSBjb25kaXRpb24gYmV0d2VlbiByb3V0ZSBsb29rdXAgYW5kCiBpbnZhbGlkYXRpb24KClsg
dXBzdHJlYW0gY29tbWl0IDUwMThjNTk2MDdhNTExY2RlZTc0M2I2MjljNzYyMDZkOWM5ZTZkN2Ig
XQoKSmVzc2UgYW5kIElkbyByZXBvcnRlZCB0aGUgZm9sbG93aW5nIHJhY2UgY29uZGl0aW9uOgo8
Q1BVIEEsIHQwPiAtIFJlY2VpdmVkIHBhY2tldCBBIGlzIGZvcndhcmRlZCBhbmQgY2FjaGVkIGRz
dCBlbnRyeSBpcwp0YWtlbiBmcm9tIHRoZSBuZXh0aG9wICgnbmhjLT5uaGNfcnRoX2lucHV0Jyku
IENhbGxzIHNrYl9kc3Rfc2V0KCkKCjx0MT4gLSBHaXZlbiBKZXNzZSBoYXMgYnVzeSByb3V0ZXJz
ICgiaW5nZXN0aW5nIGZ1bGwgQkdQIHJvdXRpbmcgdGFibGVzCmZyb20gbXVsdGlwbGUgSVNQcyIp
LCByb3V0ZSBpcyBhZGRlZCAvIGRlbGV0ZWQgYW5kIHJ0X2NhY2hlX2ZsdXNoKCkgaXMKY2FsbGVk
Cgo8Q1BVIEIsIHQyPiAtIFJlY2VpdmVkIHBhY2tldCBCIHRyaWVzIHRvIHVzZSB0aGUgc2FtZSBj
YWNoZWQgZHN0IGVudHJ5CmZyb20gdDAsIGJ1dCBydF9jYWNoZV92YWxpZCgpIGlzIG5vIGxvbmdl
ciB0cnVlIGFuZCBpdCBpcyByZXBsYWNlZCBpbgpydF9jYWNoZV9yb3V0ZSgpIGJ5IHRoZSBuZXdl
ciBvbmUuIFRoaXMgY2FsbHMgZHN0X2Rldl9wdXQoKSBvbiB0aGUKb3JpZ2luYWwgZHN0IGVudHJ5
IHdoaWNoIGFzc2lnbnMgdGhlIGJsYWNraG9sZSBuZXRkZXYgdG8gJ2RzdC0+ZGV2JwoKPENQVSBB
LCB0Mz4gLSBkc3RfaW5wdXQoc2tiKSBpcyBjYWxsZWQgb24gcGFja2V0IEEgYW5kIGl0IGlzIGRy
b3BwZWQgZHVlCnRvICdkc3QtPmRldicgYmVpbmcgdGhlIGJsYWNraG9sZSBuZXRkZXYKClRoZXJl
IGFyZSAyIGlzc3VlcyBpbiB0aGUgdjQgcm91dGluZyBjb2RlOgoxLiBBIHBlci1uZXRucyBjb3Vu
dGVyIGlzIHVzZWQgdG8gZG8gdGhlIHZhbGlkYXRpb24gb2YgdGhlIHJvdXRlLiBUaGF0Cm1lYW5z
IHdoZW5ldmVyIGEgcm91dGUgaXMgY2hhbmdlZCBpbiB0aGUgbmV0bnMsIHVzZXJzIG9mIGFsbCBy
b3V0ZXMgaW4KdGhlIG5ldG5zIG5lZWRzIHRvIHJlZG8gbG9va3VwLiB2NiBoYXMgYW4gaW1wbGVt
ZW50YXRpb24gb2Ygb25seQp1cGRhdGluZyBmbl9zZXJudW0gZm9yIHJvdXRlcyB0aGF0IGFyZSBh
ZmZlY3RlZC4KMi4gV2hlbiBydF9jYWNoZV92YWxpZCgpIHJldHVybnMgZmFsc2UsIHJ0X2NhY2hl
X3JvdXRlKCkgaXMgY2FsbGVkIHRvCnRocm93IGF3YXkgdGhlIGN1cnJlbnQgY2FjaGUsIGFuZCBj
cmVhdGUgYSBuZXcgb25lLiBUaGlzIHNlZW1zCnVubmVjZXNzYXJ5IGJlY2F1c2UgYXMgbG9uZyBh
cyB0aGlzIHJvdXRlIGRvZXMgbm90IGNoYW5nZSwgdGhlIHJvdXRlCmNhY2hlIGRvZXMgbm90IG5l
ZWQgdG8gYmUgcmVjcmVhdGVkLgoKVG8gZnVsbHkgc29sdmUgdGhlIGFib3ZlIDIgaXNzdWVzLCBp
dCBwcm9iYWJseSBuZWVkcyBxdWl0ZSBzb21lIGNvZGUKY2hhbmdlcyBhbmQgcmVxdWlyZXMgY2Fy
ZWZ1bCB0ZXN0aW5nLCBhbmQgZG9lcyBub3Qgc3VpdGUgZm9yIG5ldCBicmFuY2guCgpTbyB0aGlz
IHBhdGNoIG9ubHkgdHJpZXMgdG8gYWRkIHRoZSBkZWxldGVkIGNhY2hlZCBydCBpbnRvIHRoZSB1
bmNhY2hlZApsaXN0LCBzbyB1c2VyIGNvdWxkIHN0aWxsIGJlIGFibGUgdG8gdXNlIGl0IHRvIHJl
Y2VpdmUgcGFja2V0cyB1bnRpbAppdCdzIGRvbmUuCgpGaXhlczogOTVjNDdmOWNmNWUwICgiaXB2
NDogY2FsbCBkc3RfZGV2X3B1dCgpIHByb3Blcmx5IikKU2lnbmVkLW9mZi1ieTogV2VpIFdhbmcg
PHdlaXdhbkBnb29nbGUuY29tPgpSZXBvcnRlZC1ieTogSWRvIFNjaGltbWVsIDxpZG9zY2hAaWRv
c2NoLm9yZz4KUmVwb3J0ZWQtYnk6IEplc3NlIEhhdGhhd2F5IDxqZXNzZUBtYnVraS1tdnVraS5v
cmc+ClRlc3RlZC1ieTogSmVzc2UgSGF0aGF3YXkgPGplc3NlQG1idWtpLW12dWtpLm9yZz4KQWNr
ZWQtYnk6IE1hcnRpbiBLYUZhaSBMYXUgPGthZmFpQGZiLmNvbT4KQ2M6IERhdmlkIEFoZXJuIDxk
c2FoZXJuQGdtYWlsLmNvbT4KUmV2aWV3ZWQtYnk6IElkbyBTY2hpbW1lbCA8aWRvc2NoQG1lbGxh
bm94LmNvbT4KU2lnbmVkLW9mZi1ieTogRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQu
bmV0PgpTaWduZWQtb2ZmLWJ5OiBDYXJzdGVuIFNjaG1pZCA8Y2Fyc3Rlbl9zY2htaWRAbWVudG9y
LmNvbT4KLS0tCiBuZXQvaXB2NC9yb3V0ZS5jIHwgMzggKysrKysrKysrKysrKysrKysrKy0tLS0t
LS0tLS0tLS0tLS0tLS0KIDEgZmlsZSBjaGFuZ2VkLCAxOSBpbnNlcnRpb25zKCspLCAxOSBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9uZXQvaXB2NC9yb3V0ZS5jIGIvbmV0L2lwdjQvcm91dGUu
YwppbmRleCBjMjViM2JlNzhlMDIuLjdlYjhmMzA0OGM4NiAxMDA2NDQKLS0tIGEvbmV0L2lwdjQv
cm91dGUuYworKysgYi9uZXQvaXB2NC9yb3V0ZS5jCkBAIC0xNDMyLDYgKzE0MzIsMjQgQEAgc3Rh
dGljIGJvb2wgcnRfYmluZF9leGNlcHRpb24oc3RydWN0IHJ0YWJsZSAqcnQsIHN0cnVjdCBmaWJf
bmhfZXhjZXB0aW9uICpmbmhlLAogCXJldHVybiByZXQ7CiB9CiAKK3N0cnVjdCB1bmNhY2hlZF9s
aXN0IHsKKwlzcGlubG9ja190CQlsb2NrOworCXN0cnVjdCBsaXN0X2hlYWQJaGVhZDsKK307CisK
K3N0YXRpYyBERUZJTkVfUEVSX0NQVV9BTElHTkVEKHN0cnVjdCB1bmNhY2hlZF9saXN0LCBydF91
bmNhY2hlZF9saXN0KTsKKworc3RhdGljIHZvaWQgcnRfYWRkX3VuY2FjaGVkX2xpc3Qoc3RydWN0
IHJ0YWJsZSAqcnQpCit7CisJc3RydWN0IHVuY2FjaGVkX2xpc3QgKnVsID0gcmF3X2NwdV9wdHIo
JnJ0X3VuY2FjaGVkX2xpc3QpOworCisJcnQtPnJ0X3VuY2FjaGVkX2xpc3QgPSB1bDsKKworCXNw
aW5fbG9ja19iaCgmdWwtPmxvY2spOworCWxpc3RfYWRkX3RhaWwoJnJ0LT5ydF91bmNhY2hlZCwg
JnVsLT5oZWFkKTsKKwlzcGluX3VubG9ja19iaCgmdWwtPmxvY2spOworfQorCiBzdGF0aWMgYm9v
bCBydF9jYWNoZV9yb3V0ZShzdHJ1Y3QgZmliX25oICpuaCwgc3RydWN0IHJ0YWJsZSAqcnQpCiB7
CiAJc3RydWN0IHJ0YWJsZSAqb3JpZywgKnByZXYsICoqcDsKQEAgLTE0NTEsNyArMTQ2OSw3IEBA
IHN0YXRpYyBib29sIHJ0X2NhY2hlX3JvdXRlKHN0cnVjdCBmaWJfbmggKm5oLCBzdHJ1Y3QgcnRh
YmxlICpydCkKIAlwcmV2ID0gY21weGNoZyhwLCBvcmlnLCBydCk7CiAJaWYgKHByZXYgPT0gb3Jp
ZykgewogCQlpZiAob3JpZykgewotCQkJZHN0X2Rldl9wdXQoJm9yaWctPmRzdCk7CisJCQlydF9h
ZGRfdW5jYWNoZWRfbGlzdChvcmlnKTsKIAkJCWRzdF9yZWxlYXNlKCZvcmlnLT5kc3QpOwogCQl9
CiAJfSBlbHNlIHsKQEAgLTE0NjIsMjQgKzE0ODAsNiBAQCBzdGF0aWMgYm9vbCBydF9jYWNoZV9y
b3V0ZShzdHJ1Y3QgZmliX25oICpuaCwgc3RydWN0IHJ0YWJsZSAqcnQpCiAJcmV0dXJuIHJldDsK
IH0KIAotc3RydWN0IHVuY2FjaGVkX2xpc3QgewotCXNwaW5sb2NrX3QJCWxvY2s7Ci0Jc3RydWN0
IGxpc3RfaGVhZAloZWFkOwotfTsKLQotc3RhdGljIERFRklORV9QRVJfQ1BVX0FMSUdORUQoc3Ry
dWN0IHVuY2FjaGVkX2xpc3QsIHJ0X3VuY2FjaGVkX2xpc3QpOwotCi1zdGF0aWMgdm9pZCBydF9h
ZGRfdW5jYWNoZWRfbGlzdChzdHJ1Y3QgcnRhYmxlICpydCkKLXsKLQlzdHJ1Y3QgdW5jYWNoZWRf
bGlzdCAqdWwgPSByYXdfY3B1X3B0cigmcnRfdW5jYWNoZWRfbGlzdCk7Ci0KLQlydC0+cnRfdW5j
YWNoZWRfbGlzdCA9IHVsOwotCi0Jc3Bpbl9sb2NrX2JoKCZ1bC0+bG9jayk7Ci0JbGlzdF9hZGRf
dGFpbCgmcnQtPnJ0X3VuY2FjaGVkLCAmdWwtPmhlYWQpOwotCXNwaW5fdW5sb2NrX2JoKCZ1bC0+
bG9jayk7Ci19Ci0KIHN0YXRpYyB2b2lkIGlwdjRfZHN0X2Rlc3Ryb3koc3RydWN0IGRzdF9lbnRy
eSAqZHN0KQogewogCXN0cnVjdCBkc3RfbWV0cmljcyAqcCA9IChzdHJ1Y3QgZHN0X21ldHJpY3Mg
KilEU1RfTUVUUklDU19QVFIoZHN0KTsKLS0gCjIuMTcuMQoK

--_002_161277625185830522mentorcom_--
