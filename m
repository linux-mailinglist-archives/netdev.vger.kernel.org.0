Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177FD3002B4
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 13:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbhAVMSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 07:18:40 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:41695 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727190AbhAVMMB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 07:12:01 -0500
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20210122121108euoutp01c902fd805e1e699aadf964a3f136df0e~cjLNaCzQh2915329153euoutp01Q
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 12:11:08 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20210122121108euoutp01c902fd805e1e699aadf964a3f136df0e~cjLNaCzQh2915329153euoutp01Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611317468;
        bh=ybRq2KpLljIs5KURHyM4ORkgC3K3UjPUtTtulXxBGwg=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=hkHAqcbCvQsm2RdwE/IjtXMNLfvKTu5KmHRmElKYdpKh66OlfMWvyFQ70+Yi7FS1q
         l3rp/Qtd7m1Ev5X1VvjussgYkHL4qX2k0oUzyBFsjbpZeYlxLzy1bAkr7stma3wzU4
         rGTziOpus1NEj8Jw0/nMp1aWN5sRG0iLslH4r0WU=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210122121108eucas1p238157893e07432d2a7ece88264cebf92~cjLNSDIWb0469304693eucas1p2C;
        Fri, 22 Jan 2021 12:11:08 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 32.5C.44805.CD0CA006; Fri, 22
        Jan 2021 12:11:08 +0000 (GMT)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20210122121108eucas1p2d153ab9c3a95015221b470a66a0c8458~cjLM028Mp0464504645eucas1p2E;
        Fri, 22 Jan 2021 12:11:08 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210122121107eusmtrp2506aacfdd2a6c09334b6edbf8c84a3d4~cjLM0Qg9A3059630596eusmtrp2N;
        Fri, 22 Jan 2021 12:11:07 +0000 (GMT)
X-AuditID: cbfec7f4-b4fff7000000af05-3e-600ac0dc0745
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id BC.E6.16282.BD0CA006; Fri, 22
        Jan 2021 12:11:07 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210122121107eusmtip2e1c673413bb8fb31c448c2303429d330~cjLMZaxxm2180921809eusmtip28;
        Fri, 22 Jan 2021 12:11:07 +0000 (GMT)
Subject: Re: [PATCH v2] cfg80211: avoid holding the RTNL when calling the
 driver
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, Oliver Neukum <oneukum@suse.com>,
        Johannes Berg <johannes.berg@intel.com>
From:   Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <6569c83a-11b0-7f13-4b4c-c0318780895c@samsung.com>
Date:   Fri, 22 Jan 2021 13:11:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0)
        Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210119102145.99917b8fc5d6.Iacd5916c0e01f71342159f6d419e56dc4c3f07a2@changeid>
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42LZduzned07B7gSDE4ulLB4tGIWu8XHDZ9Y
        LN6suMNucWyBmEXX45VsDqwei/e8ZPLo793G4rF+y1UWj8+b5AJYorhsUlJzMstSi/TtErgy
        rv64wFSwV6Fi3qkHjA2M96S7GDk5JARMJD5ue8vaxcjFISSwglHi05RFzBDOF0aJvj39bBDO
        Z0aJnv5GFpiWw1O7oKqWM0p8fHQByvnIKHFt0xZmkCphgSCJmxu3gXWICPhL7DvQwA5iMwuk
        S9ydNhssziZgKNH1tosNxOYVsJP49P0lmM0ioCrRNeklWI2oQJLE3TuHmSBqBCVOznwCFOfg
        4BSIlXi13AJipLxE89bZzBC2uMStJ/OZIA49wiHxfL48hO0icffrZqi4sMSr41vYIWwZif87
        Qeq5gOxmRomH59ayQzg9jBKXm2YwQlRZS9w594sNZDGzgKbE+l36EGFHiaZbG1lBwhICfBI3
        3gpC3MAnMWnbdGaIMK9ER5sQRLWaxKzj6+DWHrxwiXkCo9IsJI/NQvLNLCTfzELYu4CRZRWj
        eGppcW56arFRXmq5XnFibnFpXrpecn7uJkZgijn97/iXHYzLX33UO8TIxMF4iFGCg1lJhPeR
        JUeCEG9KYmVValF+fFFpTmrxIUZpDhYlcd6kLWvihQTSE0tSs1NTC1KLYLJMHJxSDUwCUgpm
        ky77/P518kKUgdqOVxsTqy/5Lmf2VOtVL7ye59R0bl4cV/zLOwUHdy0TW5bj++ra/NacVQ3N
        d04k7+R5W2qncnV1cHSXxFRTH20ua++SdZ0bO54cLQ59vyLlVOOKRw9WpS//HRGsFb+8YMaz
        bZvmODecc+ZakH5zsmPJOcUFr5QXlC5M36vv//SJ9f0G9jP2m8yE3q0Q/S/BKKxqLiJx0iAl
        51qIv1IJ5w12/YXhzZrGCn+V2E85sQYwfZ7A5LO7f9+9D7Y3P+xYrPDXaeKeCUE87slVqYGt
        nc0fmZfmO3pnZ+925l6/zzY1YcuK3Ydu3VXdti1600X322fZalb89u+4oHzjWaExY7ISS3FG
        oqEWc1FxIgDVglzzoAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsVy+t/xe7q3D3AlGFydZ2rxaMUsdouPGz6x
        WLxZcYfd4tgCMYuuxyvZHFg9Fu95yeTR37uNxWP9lqssHp83yQWwROnZFOWXlqQqZOQXl9gq
        RRtaGOkZWlroGZlY6hkam8daGZkq6dvZpKTmZJalFunbJehlXP1xgalgr0LFvFMPGBsY70l3
        MXJySAiYSBye2sXcxcjFISSwlFFiet9dVoiEjMTJaQ1QtrDEn2tdbBBF7xkl9rWeB0sICwRJ
        3Ny4jQXEFhHwlVhw5z07iM0skC7R/v8yM4gtJBAjcWLvNkYQm03AUKLrLcggTg5eATuJT99f
        gtksAqoSXZNegs0RFUiSODHrEzNEjaDEyZlPgOIcHJwCsRKvlltAjDeTmLf5ITOELS/RvHU2
        lC0ucevJfKYJjEKzkHTPQtIyC0nLLCQtCxhZVjGKpJYW56bnFhvpFSfmFpfmpesl5+duYgTG
        1LZjP7fsYFz56qPeIUYmDsZDjBIczEoivI8sORKEeFMSK6tSi/Lji0pzUosPMZoCvTORWUo0
        OR8Y1Xkl8YZmBqaGJmaWBqaWZsZK4rwmR9bECwmkJ5akZqemFqQWwfQxcXBKNTAJXtJ9tEoo
        6niNnfOarQ1/l85Lsz43qySN21Tdqqqu4FTEX0HfW1dMT4V95u/eH9h5pmTRtyd77QWP602z
        slrcp3a9UvU4u5bami3Xu/W95uYv0rXvn1zl94bVcXZ18N2Y8F7Wyn8akrq7zbT2PA1aGDol
        OtdclW/ZB4fWdQt4ph7yYpNf+vAW85pyv9JQmdQtC1vYL6m+/jI/dm62TOHnR7vYnxjkpwvu
        4bWz+v9o1fdk7aNLH93gqO6xW2gYfm++svkFbcuCxqla+sWLf6m2cy99+0f63XkWeefIWfOa
        1T50H5TPYEw4NPmTU+F9I5M3kU8EvGrmWe5kuPHmhdtElgs2Vy83PLtredNy5lwlluKMREMt
        5qLiRACb6EH7MgMAAA==
X-CMS-MailID: 20210122121108eucas1p2d153ab9c3a95015221b470a66a0c8458
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20210122121108eucas1p2d153ab9c3a95015221b470a66a0c8458
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20210122121108eucas1p2d153ab9c3a95015221b470a66a0c8458
References: <20210119102145.99917b8fc5d6.Iacd5916c0e01f71342159f6d419e56dc4c3f07a2@changeid>
        <CGME20210122121108eucas1p2d153ab9c3a95015221b470a66a0c8458@eucas1p2.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Johannes,

On 19.01.2021 10:21, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Currently, _everything_ in cfg80211 holds the RTNL, and if you
> have a slow USB device (or a few) you can get some bad lock
> contention on that.
>
> Fix that by re-adding a mutex to each wiphy/rdev as we had at
> some point, so we have locking for the wireless_dev lists and
> all the other things in there, and also so that drivers still
> don't have to worry too much about it (they still won't get
> parallel calls for a single device).
>
> Then, we can restrict the RTNL to a few cases where we add or
> remove interfaces and really need the added protection. Some
> of the global list management still also uses the RTNL, since
> we need to have it anyway for netdev management, but we only
> hold the RTNL for very short periods of time here.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

This patch landed in today's (20210122) linux-next as commit 
791daf8fc49a ("cfg80211: avoid holding the RTNL when calling the 
driver"). Sadly, it causes deadlock with mwifiex driver. I think that 
lockdep report describes it enough:

Bluetooth: vendor=0x2df, device=0x912e, class=255, fn=2
cfg80211: Loading compiled-in X.509 certificates for regulatory database
cfg80211: Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
Bluetooth: FW download over, size 800344 bytes
btmrvl_sdio mmc2:0001:2: sdio device tree data not available
mwifiex_sdio mmc2:0001:1: WLAN is not the winner! Skip FW dnld
mwifiex_sdio mmc2:0001:1: WLAN FW is active
mwifiex_sdio mmc2:0001:1: CMD_RESP: cmd 0x242 error, result=0x2
mwifiex_sdio mmc2:0001:1: mwifiex_process_cmdresp: cmd 0x242 failed 
during       initialization

============================================
WARNING: possible recursive locking detected
5.11.0-rc4-00535-g791daf8fc49a #2336 Not tainted
--------------------------------------------
kworker/2:3/108 is trying to acquire lock:
c4f62b38 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: _mwifiex_fw_dpc+0x2c0/0x49c 
[mwifiex]

but task is already holding lock:
c4f62b38 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: _mwifiex_fw_dpc+0x248/0x49c 
[mwifiex]

other info that might help us debug this:
  Possible unsafe locking scenario:

        CPU0
        ----
   lock(&rdev->wiphy.mtx);
   lock(&rdev->wiphy.mtx);

  *** DEADLOCK ***

  May be due to missing lock nesting notation

4 locks held by kworker/2:3/108:
  #0: c1c066a8 ((wq_completion)events){+.+.}-{0:0}, at: 
process_one_work+0x24c/0x888
  #1: deccbf10 ((work_completion)(&fw_work->work)){+.+.}-{0:0}, at: 
process_one_work+0x24c/0x888
  #2: c13202dc (rtnl_mutex){+.+.}-{3:3}, at: _mwifiex_fw_dpc+0x23c/0x49c 
[mwifiex]
  #3: c4f62b38 (&rdev->wiphy.mtx){+.+.}-{3:3}, at: 
_mwifiex_fw_dpc+0x248/0x49c [mwifiex]

stack backtrace:
CPU: 2 PID: 108 Comm: kworker/2:3 Not tainted 
5.11.0-rc4-00535-g791daf8fc49a #2336
Hardware name: Samsung Exynos (Flattened Device Tree)
Workqueue: events request_firmware_work_func
[<c01116e8>] (unwind_backtrace) from [<c010cf58>] (show_stack+0x10/0x14)
[<c010cf58>] (show_stack) from [<c0b3ad3c>] (dump_stack+0xa4/0xc4)
[<c0b3ad3c>] (dump_stack) from [<c0195fd8>] (__lock_acquire+0xc20/0x31cc)
[<c0195fd8>] (__lock_acquire) from [<c019923c>] (lock_acquire+0x2e4/0x5dc)
[<c019923c>] (lock_acquire) from [<c0b4217c>] (__mutex_lock+0xa4/0xb60)
[<c0b4217c>] (__mutex_lock) from [<c0b42c54>] (mutex_lock_nested+0x1c/0x24)
[<c0b42c54>] (mutex_lock_nested) from [<bf1c87f8>] 
(_mwifiex_fw_dpc+0x2c0/0x49c [mwifiex])
[<bf1c87f8>] (_mwifiex_fw_dpc [mwifiex]) from [<c06bfd18>] 
(request_firmware_work_func+0x58/0x94)
[<c06bfd18>] (request_firmware_work_func) from [<c0149d48>] 
(process_one_work+0x30c/0x888)
[<c0149d48>] (process_one_work) from [<c014a31c>] (worker_thread+0x58/0x594)
[<c014a31c>] (worker_thread) from [<c0151284>] (kthread+0x154/0x19c)
[<c0151284>] (kthread) from [<c010011c>] (ret_from_fork+0x14/0x38)
Exception stack(0xdeccbfb0 to 0xdeccbff8)
...

 > ...

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

