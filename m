Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAE54D353D
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:08:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727807AbfJKAHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:07:45 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:25826 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726836AbfJKAHp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:07:45 -0400
Received: from pps.filterd (m0122332.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9B07Bgr017761;
        Fri, 11 Oct 2019 01:07:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type; s=jan2016.eng;
 bh=C4aWW2k330l4W11V+Ug8qYS/HesRDqKyQVwrvXwvev4=;
 b=nuT85BDZAeEHiTLOaAnyEuLWe3bu2F5VxzIPz0fOCNf6AIAVD+6sD+Cs2Bj+SzMYKrS1
 dr0XoXNgUswV60AnOJQhl+ibocIXZ7Ool5hmP3VJ8HK27HqHLm0xLDzKqSej+co3esNh
 ELXiuX3dIwSw+t6786xdEhWJ4pfBbLWra2sNA9Ui+u+4DgBrDyTPrhhbVZe8AdU9f/ju
 QzjqEAR+NwpnRCFf28ClgDjSggtgDIfZZzyiYAg4LMyndFWZiTEe7CxPSQwIBc2QtDjr
 fOxfQB4dxU0xngtZIUw5flG54lh7xgR+WPqverSY7Q3QB5/SXXBYIUS2mcXJaqcWLbMt /Q== 
Received: from prod-mail-ppoint7 (prod-mail-ppoint7.akamai.com [96.6.114.121] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2vek7jp0d2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 01:07:35 +0100
Received: from pps.filterd (prod-mail-ppoint7.akamai.com [127.0.0.1])
        by prod-mail-ppoint7.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x9B02q7S010650;
        Thu, 10 Oct 2019 20:07:34 -0400
Received: from prod-mail-relay15.akamai.com ([172.27.17.40])
        by prod-mail-ppoint7.akamai.com with ESMTP id 2veph0sebm-1;
        Thu, 10 Oct 2019 20:07:33 -0400
Received: from [0.0.0.0] (prod-ssh-gw02.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay15.akamai.com (Postfix) with ESMTP id 3461A2006D;
        Fri, 11 Oct 2019 00:07:33 +0000 (GMT)
Subject: Re: [PATCH 0/3] igb, ixgbe, i40e UDP segmentation offload support
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>
References: <1570658777-13459-1-git-send-email-johunt@akamai.com>
 <CAKgT0UdBPYRnwAuOGhCBAJSRhdHcnw28Tznr0GPAtqe-JWFjTQ@mail.gmail.com>
 <cd8ac880-61fe-b064-6271-993e8c6eee65@akamai.com>
 <CAKgT0UfXgzur2TGv1dNw0PQXAP0C=bNoJY6gnthASeQrHr66AA@mail.gmail.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <0e0e706c-4ce9-c27a-af55-339b4eb6d524@akamai.com>
Date:   Thu, 10 Oct 2019 17:07:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKgT0UfXgzur2TGv1dNw0PQXAP0C=bNoJY6gnthASeQrHr66AA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------44B0E7845A5CB9B49D5C7EA9"
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-10_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100211
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_09:2019-10-10,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1011
 malwarescore=0 impostorscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910100212
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a multi-part message in MIME format.
--------------44B0E7845A5CB9B49D5C7EA9
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/19 2:32 PM, Alexander Duyck wrote:
> On Thu, Oct 10, 2019 at 2:17 PM Josh Hunt <johunt@akamai.com> wrote:
>>
>> On 10/9/19 3:44 PM, Alexander Duyck wrote:
>>> On Wed, Oct 9, 2019 at 3:08 PM Josh Hunt <johunt@akamai.com> wrote:
>>>>
>>>> Alexander Duyck posted a series in 2018 proposing adding UDP segmentation
>>>> offload support to ixgbe and ixgbevf, but those patches were never
>>>> accepted:
>>>>
>>>> https://lore.kernel.org/netdev/20180504003556.4769.11407.stgit@localhost.localdomain/
>>>>
>>>> This series is a repost of his ixgbe patch along with a similar
>>>> change to the igb and i40e drivers. Testing using the udpgso_bench_tx
>>>> benchmark shows a noticeable performance improvement with these changes
>>>> applied.
>>>>
>>>> All #s below were run with:
>>>> udpgso_bench_tx -C 1 -4 -D 172.25.43.133 -z -l 30 -u -S 0 -s $pkt_size
>>>>
>>>> igb::
>>>>
>>>> SW GSO (ethtool -K eth0 tx-udp-segmentation off):
>>>> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
>>>> ========================================================================
>>>> 1472            120143.64       113     81263   81263   83.55   1.35
>>>> 2944            120160.09       114     40638   40638   62.88   1.81
>>>> 5888            120160.64       114     20319   20319   43.59   2.61
>>>> 11776           120160.76       114     10160   10160   37.52   3.03
>>>> 23552           120159.25       114     5080    5080    34.75   3.28
>>>> 47104           120160.55       114     2540    2540    32.83   3.47
>>>> 61824           120160.56       114     1935    1935    32.09   3.55
>>>>
>>>> HW GSO offload (ethtool -K eth0 tx-udp-segmentation on):
>>>> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
>>>> ========================================================================
>>>> 1472            120144.65       113     81264   81264   83.03   1.36
>>>> 2944            120161.56       114     40638   40638   41      2.78
>>>> 5888            120160.23       114     20319   20319   23.76   4.79
>>>> 11776           120161.16       114     10160   10160   15.82   7.20
>>>> 23552           120156.45       114     5079    5079    12.8    8.90
>>>> 47104           120159.33       114     2540    2540    8.82    12.92
>>>> 61824           120158.43       114     1935    1935    8.24    13.83
>>>>
>>>> ixgbe::
>>>> SW GSO:
>>>> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
>>>> ========================================================================
>>>> 1472            1070565.90      1015    724112  724112  100     10.15
>>>> 2944            1201579.19      1140    406342  406342  95.69   11.91
>>>> 5888            1201217.55      1140    203185  203185  55.38   20.58
>>>> 11776           1201613.49      1140    101588  101588  42.15   27.04
>>>> 23552           1201631.32      1140    50795   50795   35.97   31.69
>>>> 47104           1201626.38      1140    25397   25397   33.51   34.01
>>>> 61824           1201625.52      1140    19350   19350   32.83   34.72
>>>>
>>>> HW GSO Offload:
>>>> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
>>>> ========================================================================
>>>> 1472            1058681.25      1004    715954  715954  100     10.04
>>>> 2944            1201730.86      1134    404254  404254  61.28   18.50
>>>> 5888            1201776.61      1131    201608  201608  30.25   37.38
>>>> 11776           1201795.90      1130    100676  100676  16.63   67.94
>>>> 23552           1201807.90      1129    50304   50304   10.07   112.11
>>>> 47104           1201748.35      1128    25143   25143   6.8     165.88
>>>> 61824           1200770.45      1128    19140   19140   5.38    209.66
>>>>
>>>> i40e::
>>>> SW GSO:
>>>> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
>>>> ========================================================================
>>>> 1472            650122.83       616     439362  439362  100     6.16
>>>> 2944            943993.53       895     319042  319042  100     8.95
>>>> 5888            1199751.90      1138    202857  202857  82.51   13.79
>>>> 11776           1200288.08      1139    101477  101477  64.34   17.70
>>>> 23552           1201596.56      1140    50793   50793   59.74   19.08
>>>> 47104           1201597.98      1140    25396   25396   56.31   20.24
>>>> 61824           1201610.43      1140    19350   19350   55.48   20.54
>>>>
>>>> HW GSO offload:
>>>> $pkt_size       kB/s(sar)       MB/s    Calls/s Msg/s   CPU     MB2CPU
>>>> ========================================================================
>>>> 1472            657424.83       623     444653  444653  100     6.23
>>>> 2944            1201242.87      1139    406226  406226  91.45   12.45
>>>> 5888            1201739.95      1140    203199  203199  57.46   19.83
>>>> 11776           1201557.36      1140    101584  101584  36.83   30.95
>>>> 23552           1201525.17      1140    50790   50790   23.86   47.77
>>>> 47104           1201514.54      1140    25394   25394   17.45   65.32
>>>> 61824           1201478.91      1140    19348   19348   14.79   77.07
>>>>
>>>> I was not sure how to proper attribute Alexander on the ixgbe patch so
>>>> please adjust this as necessary.
>>>
>>> For the ixgbe patch I would be good with:
>>> Suggested-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
>>>
>>> The big hurdle for this will be validation. I know that there are some
>>> parts such as the 82598 in the case of the ixgbe driver or 82575 in
>>> the case of igb that didn't support the feature, and I wasn't sure
>>> about the parts supported by i40e either.  From what I can tell the
>>> x710 datasheet seems to indicate that it is supported, and you were
>>> able to get it working with your patch based on the numbers above. So
>>> that just leaves validation of the x722 and making sure there isn't
>>> anything firmware-wise on the i40e parts that may cause any issues.
>>
>> Thanks for feedback Alex.
>>
>> For validation, I will look around and see if we have any of the above
>> chips in our testbeds. The above #s are from i210, 82599ES, and x710
>> respectively. I'm happy to share my wrapper script for the gso selftest
>> if others have the missing chipsets and can verify.
>>
>> Thanks!
>> Josh
> 
> If you could share your test scripts that would be great. I believe
> the networking division will have access to more hardware so if you
> could include Aaron, who I added to the Cc, in your reply with the
> script that would be great as I am sure he can forward it on to
> whoever ends up having to ultimately test this patch set.
> 
> I'll keep an eye out for v2 of your patch set and review it when it is
> available.
> 
> Thanks.
> 
> - Alex
> 

I've attached my benchmark wrapper script udpgso_bench.sh. To run it 
you'll need to copy it, udpgso_bench_rx, and udpgso_bench_tx (built from 
kernel's selftests dir) to your DUT. It also requires a remote sink 
machine able to receive traffic on UDP 8000 (or some configured port.)
The script will copy over and start the sink process (udpgso_bench_rx) 
on the remote box.

Here's some info on how to run it:

Usage: ./udpgso_bench.sh <interface name> <remote v4 IP> [extra 
benchmark options]

Example usage:
# ./udpgso_bench.sh eth0 172.25.43.133 -u

Beware it will make some configuration changes to your local machine. It 
will overwrite:
  * /proc/sys/net/core/{optmem_max,wmem_max,wmem_default}
  * qdisc setup for <int>
  * IRQ affinity and XPS configuration for <int>

Please let me know if you hit any problems with the script. It 
originally had some akamai-specific items in it, but I (hopefully) have 
removed them all.

Josh

--------------44B0E7845A5CB9B49D5C7EA9
Content-Type: application/x-shellscript;
 name="udpgso_bench.sh"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="udpgso_bench.sh"

IyEvYmluL2Jhc2gKI3NldCAteAojIEF1dGhvcjogSm9zaCBIdW50IDxqb2h1bnRAYWthbWFp
LmNvbT4gCgppZiBbICQjIC1sdCAyIF07IHRoZW4KICAgIGVjaG8KICAgIGVjaG8gIlVzYWdl
OiAkMCA8aW50ZXJmYWNlIG5hbWU+IDxyZW1vdGUgdjQgSVA+IFtleHRyYSBiZW5jaG1hcmsg
b3B0aW9uc10iCiAgICBlY2hvCiAgICBleGl0IDEKZmkKCklOVD0iJDEiClJFTU9URT0iJDIi
CkJFTkNIX09QVFM9IiR7QDozfSIKCiMjIENoZWNrIHRoYXQgd2UgaGF2ZSB1ZHBnc29fYmVu
Y2hfKiBmaWxlcyBwcmVzZW50CmZvciBmaWxlIGluIHVkcGdzb19iZW5jaF90eCB1ZHBnc29f
YmVuY2hfcngKZG8KCWlmIFsgISAtZSAuLyR7ZmlsZX0gXTsgdGhlbgoJCWVjaG8KCQllY2hv
ICJFUlJPUjogQ2FuJ3QgZmluZCAkZmlsZS4gUGxlYXNlIGJ1aWxkIGFuZCBjb3B5IHRvICRQ
V0QiCgkJZWNobyAiICAgICAgIFlvdSBjYW4gYnVpbGQgJGZpbGUgYnkgZG9pbmc6IgoJCWVj
aG8gIiAgICAgICBtYWtlIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL25ldC8ke2ZpbGV9IgoJ
CWVjaG8KCQlleGl0IDEKCWZpCmRvbmUKCmVjaG8KZWNobyAiV0FSTklORzogVGhpcyBzY3Jp
cHQgbWF5IGNoYW5nZSB0aGUgZm9sbG93aW5nIGNvbmZpZ3VyYXRpb25zIG9uIHlvdXIgbG9j
YWwgbWFjaGluZToiCmVjaG8gIiAgICAgICAgICogc3lzY3RsczogL3Byb2Mvc3lzL25ldC9j
b3JlL3tvcHRtZW1fbWF4LHdtZW1fbWF4LHdtZW1fZGVmYXVsdH0iCmVjaG8gIiAgICAgICAg
ICogcWRpc2Mgc2V0dXAgZm9yICRJTlQiCmVjaG8gIiAgICAgICAgICogSVJRIGFmZmluaXR5
IGFuZCBYUFMgY29uZmlndXJhdGlvbiIKZWNobyAKCiMgVHdvIGZucyBiZWxvdyBib3Jyb3dl
ZCBhbmQgc2xpZ2h0bHkgbW9kaWZpZWQgZnJvbSBhIHZlciBvZiBzZXRfaXJxX2FmZmluaXR5
LnNoCnNldF9hZmZpbml0eSgpCnsKCWlmIFsgJFZFQyAtZ2UgMzIgXQoJdGhlbgoJCU1BU0tf
RklMTD0iIgoJCU1BU0tfWkVSTz0iMDAwMDAwMDAiCgkJbGV0ICJJRFggPSAkVkVDIC8gMzIi
CgkJZm9yICgoaT0xOyBpPD0kSURYO2krKykpCgkJZG8KCQkJTUFTS19GSUxMPSIke01BU0tf
RklMTH0sJHtNQVNLX1pFUk99IgoJCWRvbmUKCgkJbGV0ICJWRUMgLT0gMzIgKiAkSURYIgoJ
CU1BU0tfVE1QPSQoKDE8PCRWRUMpKQoJCU1BU0s9YHByaW50ZiAiJVglcyIgJE1BU0tfVE1Q
ICRNQVNLX0ZJTExgCgllbHNlCgkJTUFTS19UTVA9JCgoMTw8JFZFQykpCgkJTUFTSz1gcHJp
bnRmICIlWCIgJE1BU0tfVE1QYAoJZmkKCglwcmludGYgIiVzIG1hc2s9JXMgZm9yIC9wcm9j
L2lycS8lZC9zbXBfYWZmaW5pdHlcbiIgJERFViAkTUFTSyAkSVJRCglwcmludGYgIiVzIiAk
TUFTSyA+IC9wcm9jL2lycS8kSVJRL3NtcF9hZmZpbml0eQoKCXByaW50ZiAiJXMgbWFzaz0l
cyBmb3IgL3N5cy9jbGFzcy9uZXQvJXMvcXVldWVzL3R4LSVkL3hwc19jcHVzXG4iICRERVYg
JE1BU0sgJERFViAkUVVFVUUKCXByaW50ZiAiJXMiICRNQVNLID4gL3N5cy9jbGFzcy9uZXQv
JERFVi9xdWV1ZXMvdHgtJFFVRVVFL3hwc19jcHVzCn0KCmlycV9hZmZpbml0eV9jb25maWco
KSB7CgoJbG9jYWwgREVWPSIkMSIKCglmb3IgRElSIGluIHJ4IHR4IFR4UnggZnAKCWRvCgkJ
TUFYPSQoZ3JlcCAkREVWLSRESVIgL3Byb2MvaW50ZXJydXB0cyB8IHdjIC1sKQoJCWlmIFsg
IiRNQVgiID09ICIwIiBdIDsgdGhlbgoJCQlNQVg9JChlZ3JlcCAtaSAiJERFVjouKiRESVIi
IC9wcm9jL2ludGVycnVwdHMgfCB3YyAtbCkKCQlmaQoJCWlmIFsgIiRNQVgiID09ICIwIiBd
IDsgdGhlbgoJCQllY2hvIG5vICRESVIgdmVjdG9ycyBmb3VuZCBvbiAkREVWCgkJCWNvbnRp
bnVlCgkJZmkKCQltYXRjaD0xCgkJZm9yIFFVRVVFIGluICQoc2VxIDAgMSAkTUFYKQoJCWRv
CgkJCUlSUT0kKGNhdCAvcHJvYy9pbnRlcnJ1cHRzIHwgZ3JlcCAtaSAkREVWLSRESVItJFFV
RVVFIiQiICB8IGN1dCAgLWQ6ICAtZjEgfCBzZWQgInMvIC8vZyIpCgkJCVZFQz0kUVVFVUUK
CQkJaWYgWyAtbiAgIiRJUlEiIF07IHRoZW4KCQkJCXNldF9hZmZpbml0eQoJCQllbHNlCgkJ
CQlJUlE9JChjYXQgL3Byb2MvaW50ZXJydXB0cyB8IGVncmVwIC1pICRERVY6diRRVUVVRS0k
RElSIiQiICB8IGN1dCAgLWQ6ICAtZjEgfCBzZWQgInMvIC8vZyIpCgkJCQlpZiBbIC1uICAi
JElSUSIgXTsgdGhlbgoJCQkJCXNldF9hZmZpbml0eQoJCQkJZmkKCQkJZmkKCQlkb25lCglk
b25lCglpZiBbICIkbWF0Y2giIC1lcSAiMCIgXTsgdGhlbgoJCU1BWD0kKGVncmVwICRERVYt
WzAtOV0rIC9wcm9jL2ludGVycnVwdHMgfCB3YyAtbCkKCQlpZiBbICIkTUFYIiA9PSAiMCIg
XSA7IHRoZW4KCQkJZWNobyBubyB2ZWN0b3JzIGZvdW5kIG9uICRERVYKCQkJY29udGludWUK
CQlmaQoJCWZvciBRVUVVRSBpbiAkKHNlcSAwIDEgJE1BWCkKCQlkbwoJCQlJUlE9JChjYXQg
L3Byb2MvaW50ZXJydXB0cyB8IGdyZXAgLWkgJERFVi0kUVVFVUUiJCIgIHwgY3V0ICAtZDog
IC1mMSB8IHNlZCAicy8gLy9nIikKCQkJVkVDPSRRVUVVRQoJCQlpZiBbIC1uICIkSVJRIiBd
OyB0aGVuCgkJCQlzZXRfYWZmaW5pdHkKCQkJZmkKCQlkb25lCglmaQp9CgojIyBSZW1vdGUg
U2V0dXAgCmVjaG8gLW4gIlNldHRpbmcgdXAgcmVtb3RlIHJlY2VpdmVyICRSRU1PVEUuLi4i
CiMgTmVlZCB0byBtYWtlIHN1cmUgcmVtb3RlIHJlY2VpdmVyIGlzIHJ1bm5pbmcKIyAxLiBL
aWxsIG9mZiBhbnkgb2xkIHJ1bnMKc3NoIC1vICJTdHJpY3RIb3N0S2V5Q2hlY2tpbmc9bm8i
IHJvb3RAJHtSRU1PVEV9IHBraWxsIHVkcGdzb19iZW5jaF9yeCA+IC9kZXYvbnVsbCAyPiYx
CiNpZiBbICQ/IC1uZSAwIF07IHRoZW4KIwllY2hvCiMJZWNobyAiRVJST1I6IFByb2JsZW0g
dHJ5aW5nIHRvIGtpbGwgcmVjZWl2ZXIgb24gJFJFTU9URSIKIwlleGl0IDEKI2ZpCiMgMi4g
Q29weSBvdmVyIHRoZSBiaW5hcnkgd2Ugd2FudCB0byB1c2UKc2NwIC1vICJTdHJpY3RIb3N0
S2V5Q2hlY2tpbmc9bm8iIC4vdWRwZ3NvX2JlbmNoX3J4IHJvb3RAJHtSRU1PVEV9Oi92YXIv
dG1wID4gL2Rldi9udWxsIDI+JjEKaWYgWyAkPyAtbmUgMCBdOyB0aGVuCgllY2hvCgllY2hv
ICJFUlJPUjogQ2FuJ3QgY29weSByZWNlaXZlciB0byAkUkVNT1RFIgoJZXhpdCAxCmZpCiMg
My4gU3RhcnQgcmVjZWl2ZXIKc3NoIC1vICJTdHJpY3RIb3N0S2V5Q2hlY2tpbmc9bm8iIHJv
b3RAJHtSRU1PVEV9ICIvdmFyL3RtcC91ZHBnc29fYmVuY2hfcnggPiAvZGV2L251bGwgMj4g
L2Rldi9udWxsIDwgL2Rldi9udWxsICYiID4gL2Rldi9udWxsIDI+JjEKaWYgWyAkPyAtbmUg
MCBdOyB0aGVuCgllY2hvCgllY2hvICJFUlJPUjogUHJvYmxlbSBzdGFydGluZyByZWNlaXZl
ciBvbiAkUkVNT1RFIgoJZXhpdCAxCmZpCiMgNC4gQ2hlY2sgcmVjZWl2ZXIgaXMgcnVubmlu
ZyBvbiByZW1vdGUKcnhfY291bnQ9IiQoc3NoIC1vICdTdHJpY3RIb3N0S2V5Q2hlY2tpbmc9
bm8nIHJvb3RAJHtSRU1PVEV9ICdwZ3JlcCB1ZHBnc29fYmVuY2hfcnggfCB3YyAtbCcgMj4g
L2Rldi9udWxsKSIKaWYgW1sgLXogIiRyeF9jb3VudCIgfHwgJHJ4X2NvdW50IC1ndCAxIF1d
OyB0aGVuCgllY2hvCgllY2hvICJFUlJPUjogUHJvYmxlbSB3aXRoIHJlY2VpdmVyIHJ1bm5p
bmcgb24gJFJFTU9URS4iCglpZiBbIC1uICIkcnhfY291bnQiIF07IHRoZW4KCQllY2hvICJU
aGVyZSBhcmUgJHJ4X2NvdW50IGluc3RhbmNlcyBjdXJyZW50bHkgcnVubmluZy4iCglmaQoJ
ZXhpdCAxCmZpCmVjaG8gIkRvbmUuIgojIwoKIyMgTG9jYWwgU2V0dXAKIyBTZXR1cCBzeXNj
dGxzCmVjaG8gIlJ1bm5pbmcgbG9jYWwgc2V0dXAuLi4iCmVjaG8gLWUgIlx0Q29uZmlndXJp
bmcgc3lzY3Rscy4uLiIKT1BUTUVNX01BWD0iL3Byb2Mvc3lzL25ldC9jb3JlL29wdG1lbV9t
YXgiCmVjaG8gJCgoIDQgKiAxMDI0ICogMTAyNCApKSA+ICRPUFRNRU1fTUFYCmVjaG8gLWUg
Ilx0XHQkT1BUTUVNX01BWCAtPiAkKGNhdCAkT1BUTUVNX01BWCkiCldNRU1fTUFYPSIvcHJv
Yy9zeXMvbmV0L2NvcmUvd21lbV9tYXgiCmVjaG8gJCgoIDQgKiAxMDI0ICogMTAyNCApKSA+
ICRXTUVNX01BWAplY2hvIC1lICJcdFx0JFdNRU1fTUFYIC0+ICQoY2F0ICRXTUVNX01BWCki
CldNRU1fREVGPSIvcHJvYy9zeXMvbmV0L2NvcmUvd21lbV9kZWZhdWx0IgplY2hvICQoKCA1
MTIgKiAxMDI0ICkpID4gJFdNRU1fREVGCmVjaG8gLWUgIlx0XHQkV01FTV9ERUYgLT4gJChj
YXQgJFdNRU1fREVGKSIKCmVjaG8gLWUgIlx0VFggVURQIFNlZ21lbmF0aW9uIHNldHRpbmdz
OiIKZWNobyAtbmUgIlx0XHQkSU5UOiAiCmV0aHRvb2wgLWsgJElOVCAyPiAvZGV2L251bGwg
fCBncmVwIHR4LXVkcC1zZWdtZW50YXRpb24gfHwgZWNobwoKZWNobyAtZSAiXHRSZXNldCBh
bmQgRHVtcCBxZGlzYyBjb25maWcgZm9yICR7SU5UfS4uLiIKdGMgcWRpc2MgZGVsIGRldiAi
JElOVCIgcm9vdCAyPiAvZGV2L251bGwKdGMgcWRpc2Mgc2hvdyB8IGVncmVwICIkSU5UIiB8
IGF3ayAneyBwcmludGYgIlx0XHQiJDAiXG4iIH0nCgplY2hvIC1lICJcdFNldHRpbmcgSVJR
IGFmZmluaXR5IGFuZCBYUFMgY29uZmlndXJhdGlvbiBmb3IgJHtJTlR9Li4uIgppcnFfYWZm
aW5pdHlfY29uZmlnICR7SU5UfSB8IGF3ayAneyBwcmludGYgIlx0XHQiJDAiXG4iIH0nCgoj
IEZvciBpbmZvcm1hdGlvbmFsIHB1cnBvc2VzIHByaW50IHRoZSBrZXJuZWwgdmVyc2lvbgpl
Y2hvIC1uZSAiXHRLZXJuZWwgdmVyc2lvbjogIgp1bmFtZSAtcgoKZWNobyAtbmUgIlx0S2Vy
bmVsIGNvbW1hbmRsaW5lOiAiCmNhdCAvcHJvYy9jbWRsaW5lCgplY2hvIC1uZSAiXHRDUFUg
IgpncmVwIC1tMSAnbW9kZWwgbmFtZScgL3Byb2MvY3B1aW5mbwplY2hvIC1uZSAiXHRDUFUg
TWljcm9jb2RlOiAiCmdyZXAgLW0xIG1pY3JvY29kZSAvcHJvYy9jcHVpbmZvIHwgYXdrICd7
IHByaW50ICQzIH0nCgplY2hvICJMb2NhbCBzZXR1cCBjb21wbGV0ZS4iCmVjaG8KZWNobyAi
UnVubmluZyBjb21tYW5kOiIKQ01EPSIuL3VkcGdzb19iZW5jaF90eCAtQyAxIC00IC1EICRS
RU1PVEUgLXogLWwgMzAgLVMgMCAkQkVOQ0hfT1BUUyIKZWNobyAiJENNRCAtcyBcJHBrdF9z
aXplIgplY2hvCiMjCmVjaG8gLWUgIlwkcGt0X3NpemVcdGtCL3Moc2FyKVx0TUIvc1x0Q2Fs
bHMvc1x0TXNnL3NcdENQVVx0TUIyQ1BVIgplY2hvICI9PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0iCmZv
ciB4IGluICQoc2VxIDAgNik7IGRvCiAgICBzaXplPSIkKCggMTQ3MiAqICQoKCAxIDw8ICR4
ICkpICkpIjsKICAgIGlmIFsgJHNpemUgLWd0ICQoKCAxNDcyICogNDIgKSkgXTsgdGhlbgog
ICAgICAgIHNpemU9JCgoIDE0NzIgKiA0MiApKQogICAgZmkKICAgIG5zdGF0IC16IFVkcFNu
ZGJ1ZkVycm9ycyA+IC9kZXYvbnVsbAogICAgY21kPSIkQ01EIgogICAgY21kPSIkY21kIC1z
ICRzaXplIgogICAgZXZhbCAkY21kID4gYmVuY2gtJHtzaXplfS5sb2cgMj4mMSAmCiAgICBt
cHN0YXQgLVAgMSAyOSAxID4gbXBzdGF0LSR7c2l6ZX0ubG9nICYKICAgIHNhciAtbiBERVYg
MjkgMSA+IHNhci0ke3NpemV9LmxvZyAmCiAgICB3YWl0CiAgICBjcHV1dGlsPSIkKGdyZXAg
QXZlcmFnZSBtcHN0YXQtJHtzaXplfS5sb2cgfCBhd2sgJ3sgcHJpbnQgMTAwIC0gJDEyIH0n
KSIKICAgIG5ldHRwdXQ9IiQoZ3JlcCBBdmVyYWdlIHNhci0ke3NpemV9LmxvZyB8IGdyZXAg
JHtJTlR9IHwgYXdrICd7IHByaW50ICQ2IH0nKSIKICAgIGJlbmNoPSggJChhd2sgJ3sgbWJ5
dGUrPSQzOyBjYWxscys9JDU7IG1zZ3MrPSQ3IH0gRU5EeyBwcmludGYgIiVkICVkICVkIiwg
bWJ5dGUvTlIsIGNhbGxzL05SLCBtc2dzL05SIH0nIGJlbmNoLSR7c2l6ZX0ubG9nKSApCiAg
ICAjIFdlIGNoZWNrIGZvciBzbmRidWYgZXJyb3JzIGIvYyBiZW5jaG1hcmsgZG9lcyBub3Qg
cHJvcGVybHkgcmVjb2duaXplIGVycm9ycyByZXR1cm5lZCBmcm9tIHFkaXNjCiAgICAjIFRo
aXMgY2FuIG92ZXJpbmZsYXRlIHRyYW5zbWl0ICNzLCBzbyBzbmRidWYgZXJyb3JzIG11c3Qg
YmUgMCBpbiBvcmRlciBmb3IgdGhlIGRhdGEgdG8gY291bnQuCiAgICBzbmRidWZlcnI9JChu
c3RhdCAteiBVZHBTbmRidWZFcnJvcnMgfCBncmVwIEVycm9yIHwgYXdrICd7IHByaW50ICQy
IH0nKQogICAgaWYgWyAkc25kYnVmZXJyIC1ndCAwIF07IHRoZW4KCWVjaG8KCWVjaG8gIkVS
Uk9SOiBVRFAgU25kYnVmIEVycm9yIGNvdW50IGlzIG5vbi16ZXJvOiRzbmRidWZlcnIgZm9y
IHNpemU6JHNpemUuIEFib3J0aW5nIHRlc3QhIgogICAJZXhpdCAxCiAgICBmaQogICAgZWNo
byAtbmUgIiRzaXplXHRcdCIKICAgIGVjaG8gLW5lICIkbmV0dHB1dFx0IgogICAgZWNobyAt
bmUgIiR7YmVuY2hbMF19XHQiCiAgICBlY2hvIC1uZSAiJHtiZW5jaFsxXX1cdCIKICAgIGVj
aG8gLW5lICIke2JlbmNoWzJdfVx0IgogICAgZWNobyAtbmUgIiRjcHV1dGlsXHQiCiAgICBl
Y2hvIC1lICIkKCBiYyAtbCA8PDwgICJzY2FsZT0yOyAke2JlbmNoWzBdfSAvICRjcHV1dGls
IiApIgpkb25lCg==
--------------44B0E7845A5CB9B49D5C7EA9--
