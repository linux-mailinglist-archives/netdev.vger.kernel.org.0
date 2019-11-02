Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9EEECC84
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 01:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbfKBAyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 20:54:43 -0400
Received: from mout.gmx.net ([212.227.17.22]:46955 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726532AbfKBAyn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 20:54:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1572656068;
        bh=p/lVy2/JNMbvMv/0Xdzbe51QmUk1HIq5cR/LrwVOT4Y=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ALbmW3WZoDwMw1y0ZwzWQ8W6WELYPtkJw5Ni3EXU5e1PUVgdU6u+3gRxMHhlUqyEx
         KpzC3rm+tJT+QywodBLOxPSX3gXoG1C9VJWe7Uu2TlsM09Nm7zIpw6vsrhb5XGurCq
         0dLIQJKzsw1qei66rtW7USKXRENM3XW7icycFtyI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.162] ([37.4.249.112]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N5mGB-1huLXT2Z6B-017FdV; Sat, 02
 Nov 2019 01:54:28 +0100
Subject: Re: rtlwifi: Memory leak in rtl92c_set_fw_rsvdpagepkt()
To:     Pkshih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc:     "colin.king@canonical.com" <colin.king@canonical.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <989debc9-8602-0ce3-71a7-2bf783b2c22b@gmx.net>
 <5B2DA6FDDF928F4E855344EE0A5C39D1D5C90CAD@RTITMBSVM04.realtek.com.tw>
From:   Stefan Wahren <wahrenst@gmx.net>
Message-ID: <72e5ee88-4859-8134-825a-eb103926d2f0@gmx.net>
Date:   Sat, 2 Nov 2019 01:54:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5B2DA6FDDF928F4E855344EE0A5C39D1D5C90CAD@RTITMBSVM04.realtek.com.tw>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Provags-ID: V03:K1:hmdbVG0cIxoxaeZupXN98FztL3DSQQFmoKZDW7q+Tubkik2tRwo
 CkUBJvGIJwC5L5T1I9rk5ez6hQZ7u3HwvxBfvZXpiEwb2ghM4iTbExFu9V8jWDr3cv7hs+o
 lY+ikJ3ii1k1cTBeWzGLLmRTeG9UhjXK3Om/QNSLSQMdrizuo9VQ+K+OEyVTg3KM1+6qBjK
 SCm4/sRXwoWHa4tnE4s7A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:XGs4F5+wV9Y=:oJAnTrDTMVkDlAIKAad9Md
 gzbGrZqVbNiXxC+HcMrMBKBEqiqma7g/j0nxHgyb4ZnVQVLxeplaFNBzzPcw9CedL7iAIe1K0
 VrWBqsKDwkmC0QOD5mm64yhjORZuzoNK2B97pBRxNziS8h9CgnUb5NIDgrnHJw4OAw9Zb/Fsn
 WYcdyaOzx1O3iDSoKupqUj1kulaQaMqTpkRYX7dsexKDng8m63jLzz+iPL4tWXeXcKK0BFGrn
 DTDYO2BnEXXcu+KSSdFOfo7zpV8Z6Pxo5M/CUzX6h2hJ+4krOHaxL5VLtCGtroBBRMnBcb3cX
 nQtIHEBLT5QCi8BjuLXmVArKCJHME8UupMv/CZDvHaGCCc5IGK3Lbi7yKkEMcbW5lwa4FRaG3
 cn+gYds8BdWiWQ27SpA3ORtYL58uscVKI6RHGh48NZrH+gmmC2Z1qzcT+0udAVj3U3ODd4y5S
 yOW93dj0dFtBeKI9yKFLONqtHixso637mphAwvK80e0qe2WM3nOlms9aTj+5OhywQtDEfaNKM
 WPkaP90HMD2AMWgjvEBIETZr342mRYknE5aOgHyibKG3zztLKMbzKc240WdnR627fO79juEqD
 NinnrYtZJ0CdkHTlTCNTkdtjPNnGI6Sz7KA/vtCchfkwrm1HbW4ebqyHpdozylhtM9ScDC67u
 6ldUp5oAE4AFZJIAELW3LX859WMQPffmJ+Pzl4tCk0P4OsCzoV1Y/nJ6KMERkjodOgRPMMZ6I
 xBM2KfkidYbT7Kl0060ghnp04B+pZxaCd8yxWSiXBR+yszX2I/25XTSBnDdkCs10NfZbl+hBv
 1ZjcupNefbymcAdO6nuv/9SeH6dWH35TZylbjP0z5n9gEjUfI7fC8FhjUs2qsQ0B8N9H2Zu/k
 8AoeHtgOVIKvF1JqGavZ1mtD5wkJB1sW7ABWi0n5E9iFhu3GsW6ohnptjKoeBu2KWZErmD1VB
 mRZw0hQOkqCEJxTnotJirJkh4lXAwbleTyS1hWKiVA3NknApVf6bZj4TqKlghtHOQcNFyVrT0
 Q9TUfy0tfiWdtEAQ1sYrESxuCaEXvyqpXwazkTz0CpsnxQLDmmXNGVVD9K6jwRdO6y5LLFMON
 pw+rhEvuKyvjcDWGhmK93E93oqY75unJaZnUMwRdNI+69r/M08ySk3BlKyuE1r+kZlzinVzu0
 1c5kdATIlUj1koMq92EKctkWNT4WXvuaHamNgiMhJHbqoF4LsamGQimqxttT0KtrURtxfjkKN
 93vGQsvMR+xxHjbygWBDf5BQFH1zztZK3lgVRQd2kSDxNfFAkLZOY9P3umus=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Am 01.11.19 um 02:18 schrieb Pkshih:
>
>> -----Original Message-----
>> From: Stefan Wahren [mailto:wahrenst@gmx.net]
>> Sent: Thursday, October 31, 2019 9:57 PM
>> To: Pkshih; Larry Finger
>> Cc: colin.king@canonical.com; kvalo@codeaurora.org; linux-wireless@vger=
.kernel.org;
>> netdev@vger.kernel.org
>> Subject: rtlwifi: Memory leak in rtl92c_set_fw_rsvdpagepkt()
>>
>> Hi,
>>
>> i tested the EDIMAX EW-7612 on Raspberry Pi 3B+ with Linux 5.4-rc5
>> (multi_v7_defconfig + rtlwifi + kmemleak) and noticed a single memory
>> leak during probe:
>>
>> unreferenced object 0xec13ee40 (size 176):
>> =C2=A0 comm "kworker/u8:1", pid 36, jiffies 4294939321 (age 5580.790s)
>> =C2=A0 hex dump (first 32 bytes):
>> =C2=A0=C2=A0=C2=A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=C2=
=A0 ................
>> =C2=A0=C2=A0=C2=A0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=C2=
=A0 ................
>> =C2=A0 backtrace:
>> =C2=A0=C2=A0=C2=A0 [<fc1bbb3e>] __netdev_alloc_skb+0x9c/0x164
>> =C2=A0=C2=A0=C2=A0 [<863dfa6e>] rtl92c_set_fw_rsvdpagepkt+0x254/0x340 [=
rtl8192c_common]
>> =C2=A0=C2=A0=C2=A0 [<9572be0d>] rtl92cu_set_hw_reg+0xf48/0xfa4 [rtl8192=
cu]
>> =C2=A0=C2=A0=C2=A0 [<116df4d8>] rtl_op_bss_info_changed+0x234/0x96c [rt=
lwifi]
>> =C2=A0=C2=A0=C2=A0 [<8933575f>] ieee80211_bss_info_change_notify+0xb8/0=
x264 [mac80211]
>> =C2=A0=C2=A0=C2=A0 [<d4061e86>] ieee80211_assoc_success+0x934/0x1798 [m=
ac80211]
>> =C2=A0=C2=A0=C2=A0 [<e55adb56>] ieee80211_rx_mgmt_assoc_resp+0x174/0x31=
4 [mac80211]
>> =C2=A0=C2=A0=C2=A0 [<5974629e>] ieee80211_sta_rx_queued_mgmt+0x3f4/0x7f=
0 [mac80211]
>> =C2=A0=C2=A0=C2=A0 [<d91091c6>] ieee80211_iface_work+0x208/0x318 [mac80=
211]
>> =C2=A0=C2=A0=C2=A0 [<ac5fcae4>] process_one_work+0x22c/0x564
>> =C2=A0=C2=A0=C2=A0 [<f5e6d3b6>] worker_thread+0x44/0x5d8
>> =C2=A0=C2=A0=C2=A0 [<82c7b073>] kthread+0x150/0x154
>> =C2=A0=C2=A0=C2=A0 [<b43e1b7d>] ret_from_fork+0x14/0x2c
>> =C2=A0=C2=A0=C2=A0 [<794dff30>] 0x0
>>
>> It looks like the allocated skd is never freed.
>>
>> Would be nice to get this fixed.
>>
> Hi,
>
> This is due to 8192cu doesn't implement usb_cmd_send_packet(). Could you=
 help
> following patch?
>
> diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drive=
rs/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> index 56cc3bc30860..f070f25bb735 100644
> --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
> @@ -1540,6 +1540,8 @@ static bool usb_cmd_send_packet(struct ieee80211_h=
w *hw, struct sk_buff *skb)
>     * This is maybe necessary:
>     * rtlpriv->cfg->ops->fill_tx_cmddesc(hw, buffer, 1, 1, skb);
>     */
> +       dev_kfree_skb(skb);
> +
>         return true;
>  }
>
> This patch just frees the skb to resolve memleak problem. Since 8192cu d=
oesn't
> turn on fwctrl_lps that needs to download command packet to firmware, ap=
ply
> this patch isn't worse than before.

Yes, the patch fixes the memleak.

Thanks
Stefan

>
> ---
> PK
>
