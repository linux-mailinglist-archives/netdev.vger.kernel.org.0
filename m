Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7311D286000
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 15:22:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgJGNWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 09:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:37628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728271AbgJGNWk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 09:22:40 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E17920870;
        Wed,  7 Oct 2020 13:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602076957;
        bh=xSM/bftSFTQDkFevWfhJ8DAVoRRGu8guCSKn93QhX94=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=16WwxGok+UP4tDhgaRSvBf11/qhAceQcv+78JmKony5zefEPL59VkzQUhjls1iOay
         dHAQH6LsiNjuY0hymF8mA1C8ACq7eUeJp0TdC8ATN98Sq1iG7ujUL5CCMiWBOkgBGx
         KrSvq99rBwg+dkslWkP9Zm/t+NSkuXh1LyB/DBoQ=
Date:   Wed, 7 Oct 2020 15:23:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     Johan Hedberg <johan.hedberg@gmail.com>,
        Sathish Narsimman <sathish.narasimman@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "Bluetooth: Update resolving list when updating
 whitelist"
Message-ID: <20201007132321.GA2466@kroah.com>
References: <3F7BDD50-DEA3-4CB0-A9A0-69E7EE2923D5@holtmann.org>
 <20201005083624.GA2442@kroah.com>
 <220D3B4E-D73E-43AD-8FF8-887D1A628235@holtmann.org>
 <20201005124018.GA800868@kroah.com>
 <824BC92C-5035-4B80-80E7-298508E4ADD7@holtmann.org>
 <20201005161149.GA2378402@kroah.com>
 <0C92E812-BF43-46A6-A069-3F7F3278FBB4@holtmann.org>
 <20201005173835.GB2388217@kroah.com>
 <20201005180208.GA2739@kroah.com>
 <D577711C-4AF5-4E82-8A17-E766B64E15A9@holtmann.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D577711C-4AF5-4E82-8A17-E766B64E15A9@holtmann.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Mon, Oct 05, 2020 at 08:58:33PM +0200, Marcel Holtmann wrote:
> Hi Greg,
> 
> >>>>>>>>>>>>>> This reverts commit 0eee35bdfa3b472cc986ecc6ad76293fdcda59e2 as it
> >>>>>>>>>>>>>> breaks all bluetooth connections on my machine.
> >>>>>>>>>>>>>> 
> >>>>>>>>>>>>>> Cc: Marcel Holtmann <marcel@holtmann.org>
> >>>>>>>>>>>>>> Cc: Sathish Narsimman <sathish.narasimman@intel.com>
> >>>>>>>>>>>>>> Fixes: 0eee35bdfa3b ("Bluetooth: Update resolving list when updating whitelist")
> >>>>>>>>>>>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>>>>>>>>>>>>> ---
> >>>>>>>>>>>>>> net/bluetooth/hci_request.c | 41 ++-----------------------------------
> >>>>>>>>>>>>>> 1 file changed, 2 insertions(+), 39 deletions(-)
> >>>>>>>>>>>>>> 
> >>>>>>>>>>>>>> This has been bugging me for since 5.9-rc1, when all bluetooth devices
> >>>>>>>>>>>>>> stopped working on my desktop system.  I finally got the time to do
> >>>>>>>>>>>>>> bisection today, and it came down to this patch.  Reverting it on top of
> >>>>>>>>>>>>>> 5.9-rc7 restored bluetooth devices and now my input devices properly
> >>>>>>>>>>>>>> work.
> >>>>>>>>>>>>>> 
> >>>>>>>>>>>>>> As it's almost 5.9-final, any chance this can be merged now to fix the
> >>>>>>>>>>>>>> issue?
> >>>>>>>>>>>>> 
> >>>>>>>>>>>>> can you be specific what breaks since our guys and I also think the
> >>>>>>>>>>>>> ChromeOS guys have been testing these series of patches heavily.
> >>>>>>>>>>>> 
> >>>>>>>>>>>> My bluetooth trackball does not connect at all.  With this reverted, it
> >>>>>>>>>>>> all "just works".
> >>>>>>>>>>>> 
> >>>>>>>>>>>> Same I think for a Bluetooth headset, can check that again if you really
> >>>>>>>>>>>> need me to, but the trackball is reliable here.
> >>>>>>>>>>>> 
> >>>>>>>>>>>>> When you run btmon does it indicate any errors?
> >>>>>>>>>>>> 
> >>>>>>>>>>>> How do I run it and where are the errors displayed?
> >>>>>>>>>>> 
> >>>>>>>>>>> you can do btmon -w trace.log and just let it run like tcdpump.
> >>>>>>>>>> 
> >>>>>>>>>> Ok, attached.
> >>>>>>>>>> 
> >>>>>>>>>> The device is not connecting, and then I open the gnome bluetooth dialog
> >>>>>>>>>> and it scans for devices in the area, but does not connect to my
> >>>>>>>>>> existing devices at all.
> >>>>>>>>>> 
> >>>>>>>>>> Any ideas?
> >>>>>>>>> 
> >>>>>>>>> the trace file is from -rc7 or from -rc7 with this patch reverted?
> >>>>>>>>> 
> >>>>>>>>> I asked, because I see no hint that anything goes wrong. However I have a suspicion if you bisected it to this patch.
> >>>>>>>>> 
> >>>>>>>>> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> >>>>>>>>> index e0269192f2e5..94c0daa9f28d 100644
> >>>>>>>>> --- a/net/bluetooth/hci_request.c
> >>>>>>>>> +++ b/net/bluetooth/hci_request.c
> >>>>>>>>> @@ -732,7 +732,7 @@ static int add_to_white_list(struct hci_request *req,
> >>>>>>>>>             return -1;
> >>>>>>>>> 
> >>>>>>>>>     /* White list can not be used with RPAs */
> >>>>>>>>> -       if (!allow_rpa && !use_ll_privacy(hdev) &&
> >>>>>>>>> +       if (!allow_rpa &&
> >>>>>>>>>         hci_find_irk_by_addr(hdev, &params->addr, params->addr_type)) {
> >>>>>>>>>             return -1;
> >>>>>>>>>     }
> >>>>>>>>> @@ -812,7 +812,7 @@ static u8 update_white_list(struct hci_request *req)
> >>>>>>>>>             }
> >>>>>>>>> 
> >>>>>>>>>             /* White list can not be used with RPAs */
> >>>>>>>>> -               if (!allow_rpa && !use_ll_privacy(hdev) &&
> >>>>>>>>> +               if (!allow_rpa &&
> >>>>>>>>>                 hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type)) {
> >>>>>>>>>                     return 0x00;
> >>>>>>>>>             }
> >>>>>>>>> 
> >>>>>>>>> 
> >>>>>>>>> If you just do the above, does thing work for you again?
> >>>>>>>> 
> >>>>>>>> Corrupted white-space issues aside, yes, it works!
> >>>>>>> 
> >>>>>>> I just pasted it from a different terminal ;)
> >>>>>>> 
> >>>>>>>> I am running 5.9-rc8 with just this change on it and my tracball works
> >>>>>>>> just fine.
> >>>>>>>> 
> >>>>>>>>> My suspicion is that the use_ll_privacy check is the wrong one here. It only checks if hardware feature is available, not if it is also enabled.
> >>>>>>>> 
> >>>>>>>> How would one go about enabling such a hardware feature if they wanted
> >>>>>>>> to?  :)
> >>>>>>> 
> >>>>>>> I need to understand what is going wrong for you. I have a suspicion,
> >>>>>>> but first I need to understand what kind of device you have. I hope
> >>>>>>> the trace file is enough.
> >>>>>> 
> >>>>>> If you need any other information, just let me know, this is a USB
> >>>>>> Bluetooth controller from Intel:
> >>>>>> 
> >>>>>> 	$ lsusb | grep Blue
> >>>>>> 	Bus 009 Device 002: ID 8087:0029 Intel Corp. AX200 Bluetooth
> >>>>>> 
> >>>>>> And the output of usb-devices for it:
> >>>>>> 	T:  Bus=09 Lev=01 Prnt=01 Port=04 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
> >>>>>> 	D:  Ver= 2.01 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> >>>>>> 	P:  Vendor=8087 ProdID=0029 Rev=00.01
> >>>>>> 	C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
> >>>>>> 	I:  If#=0x0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> >>>>>> 	I:  If#=0x1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> >>>>> 
> >>>>> I already figured out that it is one of our controllers. The trace file gives it away.
> >>>>> 
> >>>>> So my suspicion is that the device you want to connect to uses RPA (aka random addresses). And we added support for resolving them in the firmware. Your hardware does support that, but the host side is not fully utilizing it and thus your device is filtered out.
> >>>> 
> >>>> Dude, get an email client that line-wraps :)
> >>>> 
> >>>>> If I am not mistaken, then the use_ll_privacy() check in these two specific places need to be replaced with LL Privacy Enabled check. And then the allow_rpa condition will do its job as expected.
> >>>>> 
> >>>>> We can confirm this if you send me a trace with the patch applied.
> >>>> 
> >>>> Want me to disconnect the device and then reconnect it using
> >>>> bluetootctl?  I'll go do that now...
> >>>> 
> >>>> Ok, it's attached, I did:
> >>>> 
> >>>> $ bluetoothctl disconnect F1:85:91:79:73:70
> >>>> Attempting to disconnect from F1:85:91:79:73:70
> >>>> [CHG] Device F1:85:91:79:73:70 ServicesResolved: no
> >>>> Successful disconnected
> >>>> 
> >>>> And then the gnome bluetooth daemon (or whatever it has) reconnected it
> >>>> automatically, so you can see the connection happen, and some movements
> >>>> in the log.
> >>>> 
> >>>> If there's anything else you need, just let me know.
> >>> 
> >>> so the trace file indicates that you are using static addresses and not RPAs. Now I am confused.
> >>> 
> >>> What is the content of /sys/kernel/debug/bluetooth/hci0/identity_resolving_keys?
> >> 
> >> f1:85:91:79:73:70 (type 1) f02567096e8537e5dac1cadf548fa750 00:00:00:00:00:00
> > 
> > I rebooted, and the same value was there.
> > 
> >>> The only way I can explain this if you have an entry in that file, but the device is not using it.
> >>> 
> >>> If you have btmgmt (from bluez.git) you can try "./tools/btmgmt irks” to clear that list and try again.
> >> 
> >> Ok, I did that, and reconnected, this is still with the kernel that has
> >> the patch.  Want me to reboot to a "clean" 5.9-rc8?
> > 
> > I rebooted into a clean 5.9-rc8 and the device does not connect.
> > 
> > So I did the following to trace this:
> > 
> > $ sudo btmgmt irks
> > Identity Resolving Keys successfully loaded
> > $ sudo cat /sys/kernel/debug/bluetooth/hci0/identity_resolving_keys
> > $ bluetoothctl connect F1:85:91:79:73:70
> > Attempting to connect to F1:85:91:79:73:70
> > Failed to connect: org.bluez.Error.Failed
> > 
> > and ran another btmon session to see this, it is attached.
> 
> this is confusing and makes no sense :(
> 
> What is the content of debug/bluetooth/hci0/whitelist and

# cat white_list
f1:85:91:79:73:70 (type 1)

> debug/bluetooth/hci0/device_list?

# cat device_list
2c:41:a1:4d:f2:2c (type 0)
f1:85:91:79:73:70 (type 1) 3

> The only way I can explain this is that somehow the whitelist filter doesn’t
> get programmed correctly and thus the scan will not find your device. Why
> this points to use_ll_privacy() is totally unclear to me.
> 
> Btw. reboots won’t help since bluetoothd will restore from settings. You
> need to go into the files in /var/lib/bluetooth/ and look for an entry of
> IdentityResolvingKey for your device and remove it and then restart
> bluetoothd.

I see that entry in there, let me remove it...

> You can run btmon and will even show you what bluetoothd loads during start.
> 
> Can you try to do systemctl stop bluetooth, then start btmon and then
> systemctl start bluetooth. It should reprogram the controller and I could
> see the complete trace on how it sets up your hardware.

Ok, I remove the entry for IdentityResolvingKey and restarted bluetoothd
and now it works on a clean 5.9-rc8!

I'll stop it again and run the monitor and attach it below when it
starts back up.

Ah, I did just that, and it did not connect this time.  Attached is the
trace.  No IdentityResolvingKey entries anywhere...

> If this really breaks for your, it should have been broken for weeks for
> everybody. So this is the part that is confusing to me. And my original
> suspicion turned out to be wrong.

Some bluetoothd interaction?

thanks,

greg k-h

--wac7ysb48OaltWcw
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="trace.log"
Content-Transfer-Encoding: quoted-printable

btsnoop=00=00=00=00=01=00=00=07=D1=00=00=00!=00=00=00!=FF=FF=00=0C=00=00=00=
=00=00=E2=8E=C7=A5=AA=A88Linux version 5.9.0-rc8 (x86_64)=00=00=00=00!=00=
=00=00!=FF=FF=00=0C=00=00=00=00=00=E2=8E=C7=A5=AA=A8:Bluetooth subsystem ve=
rsion 2.22=00=00=00=00=10=00=00=00=10=00=00=00=00=00=00=00=00=00=E2=8E=C7=
=A5=AA=A8;=00=01pe=F6=85=E0Phci0=00=00=00=00=00=00=00#=00=00=00#=FF=FF=00=
=0D=00=00=00=00=00=E2=8E=C7=A6=01=FA#=06=0Bbluetoothd=00Bluetooth daemon 5.=
55=00=00=00=00|=00=00=00|=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=FA|=04=
=0Bbluetoothd=00src/main.c:parse_controller_config() Key file does not have=
 key =E2=80=9CBRPageScanType=E2=80=9D in group =E2=80=9CController=E2=80=9D=
=00=00=00=00=80=00=00=00=80=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=FA=89=
=04=0Bbluetoothd=00src/main.c:parse_controller_config() Key file does not h=
ave key =E2=80=9CBRPageScanInterval=E2=80=9D in group =E2=80=9CController=
=E2=80=9D=00=00=00=00~=00=00=00~=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=
=FA=93=04=0Bbluetoothd=00src/main.c:parse_controller_config() Key file does=
 not have key =E2=80=9CBRPageScanWindow=E2=80=9D in group =E2=80=9CControll=
er=E2=80=9D=00=00=00=00=7F=00=00=00=7F=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=
=A6=01=FA=9C=04=0Bbluetoothd=00src/main.c:parse_controller_config() Key fil=
e does not have key =E2=80=9CBRInquiryScanType=E2=80=9D in group =E2=80=9CC=
ontroller=E2=80=9D=00=00=00=00=83=00=00=00=83=FF=FF=00=0D=00=00=00=00=00=E2=
=8E=C7=A6=01=FA=A5=04=0Bbluetoothd=00src/main.c:parse_controller_config() K=
ey file does not have key =E2=80=9CBRInquiryScanInterval=E2=80=9D in group =
=E2=80=9CController=E2=80=9D=00=00=00=00=81=00=00=00=81=FF=FF=00=0D=00=00=
=00=00=00=E2=8E=C7=A6=01=FA=AF=04=0Bbluetoothd=00src/main.c:parse_controlle=
r_config() Key file does not have key =E2=80=9CBRInquiryScanWindow=E2=80=9D=
 in group =E2=80=9CController=E2=80=9D=00=00=00=00=86=00=00=00=86=FF=FF=00=
=0D=00=00=00=00=00=E2=8E=C7=A6=01=FA=B8=04=0Bbluetoothd=00src/main.c:parse_=
controller_config() Key file does not have key =E2=80=9CBRLinkSupervisionTi=
meout=E2=80=9D in group =E2=80=9CController=E2=80=9D=00=00=00=00{=00=00=00{=
=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=FA=C1=04=0Bbluetoothd=00src/main=
=2Ec:parse_controller_config() Key file does not have key =E2=80=9CBRPageTi=
meout=E2=80=9D in group =E2=80=9CController=E2=80=9D=00=00=00=00=80=00=00=
=00=80=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=FA=CB=04=0Bbluetoothd=00sr=
c/main.c:parse_controller_config() Key file does not have key =E2=80=9CBRMi=
nSniffInterval=E2=80=9D in group =E2=80=9CController=E2=80=9D=00=00=00=00=
=80=00=00=00=80=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=FA=D4=04=0Bblueto=
othd=00src/main.c:parse_controller_config() Key file does not have key =E2=
=80=9CBRMaxSniffInterval=E2=80=9D in group =E2=80=9CController=E2=80=9D=00=
=00=00=00=88=00=00=00=88=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=FA=DD=04=
=0Bbluetoothd=00src/main.c:parse_controller_config() Key file does not have=
 key =E2=80=9CLEMinAdvertisementInterval=E2=80=9D in group =E2=80=9CControl=
ler=E2=80=9D=00=00=00=00=88=00=00=00=88=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=
=A6=01=FA=E6=04=0Bbluetoothd=00src/main.c:parse_controller_config() Key fil=
e does not have key =E2=80=9CLEMaxAdvertisementInterval=E2=80=9D in group =
=E2=80=9CController=E2=80=9D=00=00=00=00=92=00=00=00=92=FF=FF=00=0D=00=00=
=00=00=00=E2=8E=C7=A6=01=FA=EF=04=0Bbluetoothd=00src/main.c:parse_controlle=
r_config() Key file does not have key =E2=80=9CLEMultiAdvertisementRotation=
Interval=E2=80=9D in group =E2=80=9CController=E2=80=9D=00=00=00=00=87=00=
=00=00=87=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=FA=F8=04=0Bbluetoothd=
=00src/main.c:parse_controller_config() Key file does not have key =E2=80=
=9CLEScanIntervalAutoConnect=E2=80=9D in group =E2=80=9CController=E2=80=9D=
=00=00=00=00=85=00=00=00=85=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=FB=01=
=04=0Bbluetoothd=00src/main.c:parse_controller_config() Key file does not h=
ave key =E2=80=9CLEScanWindowAutoConnect=E2=80=9D in group =E2=80=9CControl=
ler=E2=80=9D=00=00=00=00=83=00=00=00=83=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=
=A6=01=FB
=04=0Bbluetoothd=00src/main.c:parse_controller_config() Key file does not h=
ave key =E2=80=9CLEScanIntervalSuspend=E2=80=9D in group =E2=80=9CControlle=
r=E2=80=9D=00=00=00=00=81=00=00=00=81=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=
=A6=01=FB=13=04=0Bbluetoothd=00src/main.c:parse_controller_config() Key fil=
e does not have key =E2=80=9CLEScanWindowSuspend=E2=80=9D in group =E2=80=
=9CController=E2=80=9D=00=00=00=00=85=00=00=00=85=FF=FF=00=0D=00=00=00=00=
=00=E2=8E=C7=A6=01=FB=1D=04=0Bbluetoothd=00src/main.c:parse_controller_conf=
ig() Key file does not have key =E2=80=9CLEScanIntervalDiscovery=E2=80=9D i=
n group =E2=80=9CController=E2=80=9D=00=00=00=00=83=00=00=00=83=FF=FF=00=0D=
=00=00=00=00=00=E2=8E=C7=A6=01=FB%=04=0Bbluetoothd=00src/main.c:parse_contr=
oller_config() Key file does not have key =E2=80=9CLEScanWindowDiscovery=E2=
=80=9D in group =E2=80=9CController=E2=80=9D=00=00=00=00=86=00=00=00=86=FF=
=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=FB.=04=0Bbluetoothd=00src/main.c:pa=
rse_controller_config() Key file does not have key =E2=80=9CLEScanIntervalA=
dvMonitor=E2=80=9D in group =E2=80=9CController=E2=80=9D=00=00=00=00=84=00=
=00=00=84=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=FB6=04=0Bbluetoothd=00s=
rc/main.c:parse_controller_config() Key file does not have key =E2=80=9CLES=
canWindowAdvMonitor=E2=80=9D in group =E2=80=9CController=E2=80=9D=00=00=00=
=00=83=00=00=00=83=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=FB?=04=0Bbluet=
oothd=00src/main.c:parse_controller_config() Key file does not have key =E2=
=80=9CLEScanIntervalConnect=E2=80=9D in group =E2=80=9CController=E2=80=9D=
=00=00=00=00=81=00=00=00=81=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=FBG=
=04=0Bbluetoothd=00src/main.c:parse_controller_config() Key file does not h=
ave key =E2=80=9CLEScanWindowConnect=E2=80=9D in group =E2=80=9CController=
=E2=80=9D=00=00=00=00=85=00=00=00=85=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=
=01=FBP=04=0Bbluetoothd=00src/main.c:parse_controller_config() Key file doe=
s not have key =E2=80=9CLEMinConnectionInterval=E2=80=9D in group =E2=80=9C=
Controller=E2=80=9D=00=00=00=00=85=00=00=00=85=FF=FF=00=0D=00=00=00=00=00=
=E2=8E=C7=A6=01=FBY=04=0Bbluetoothd=00src/main.c:parse_controller_config() =
Key file does not have key =E2=80=9CLEMaxConnectionInterval=E2=80=9D in gro=
up =E2=80=9CController=E2=80=9D=00=00=00=00=81=00=00=00=81=FF=FF=00=0D=00=
=00=00=00=00=E2=8E=C7=A6=01=FBq=04=0Bbluetoothd=00src/main.c:parse_controll=
er_config() Key file does not have key =E2=80=9CLEConnectionLatency=E2=80=
=9D in group =E2=80=9CController=E2=80=9D=00=00=00=00=8C=00=00=00=8C=FF=FF=
=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=FBz=04=0Bbluetoothd=00src/main.c:parse=
_controller_config() Key file does not have key =E2=80=9CLEConnectionSuperv=
isionTimeout=E2=80=9D in group =E2=80=9CController=E2=80=9D=00=00=00=00=82=
=00=00=00=82=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=FB=83=04=0Bbluetooth=
d=00src/main.c:parse_controller_config() Key file does not have key =E2=80=
=9CLEAutoconnecttimeout=E2=80=9D in group =E2=80=9CController=E2=80=9D=00=
=00=00=00=1E=00=00=00=1E=FF=FF=00=0E=00=00=00=00=00=E2=8E=C7=A6=01=FFa=01=
=00=00=00=02=00=01=12=00=01=00=00=00=10bluetoothd=00=00=00=00=00=00=00=00=
=00!=00=00=00!=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=01=FF=A6=06=0Bbluetoo=
thd=00Starting SDP server=00=00=00=00=06=00=00=00=06=FF=FF=00=10=00=00=00=
=00=00=E2=8E=C7=A6=02=0B=94=01=00=00=00=01=00=00=00=00=0C=00=00=00=0C=FF=FF=
=00=11=00=00=00=00=00=E2=8E=C7=A6=02=0B=9A=01=00=00=00=01=00=01=00=00=01=12=
=00=00=00=00=3D=00=00=00=3D=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=02=0B=F1=
=06=0Bbluetoothd=00Bluetooth management interface 1.18 initialized=00=00=00=
=00=06=00=00=00=06=FF=FF=00=10=00=00=00=00=00=E2=8E=C7=A6=02=0B=C2=01=00=00=
=00=02=00=00=00=00=F7=00=00=00=F7=FF=FF=00=11=00=00=00=00=00=E2=8E=C7=A6=02=
=0B=C4=01=00=00=00=01=00=02=00=00O=00&=00=03=00=04=00=05=00=06=00=07=00=08=
=00	=00
=00=0B=00=0C=00=0D=00=0E=00=0F=00=10=00=11=00=12=00=13=00=14=00=15=00=16=00=
=17=00=18=00=19=00=1A=00=1B=00=1C=00=1D=00=1E=00=1F=00 =00!=00"=00#=00$=00%=
=00&=00'=00(=00)=00*=00+=00,=00-=00.=00/=000=001=002=003=004=005=006=007=00=
8=009=00:=00;=00<=00=3D=00>=00?=00@=00A=00B=00C=00F=00G=00H=00I=00J=00K=00L=
=00M=00N=00O=00P=00Q=00R=00S=00=03=00=04=00=05=00=06=00=07=00=08=00	=00
=00=0B=00=0C=00=0D=00=0E=00=0F=00=10=00=11=00=12=00=13=00=14=00=15=00=16=00=
=17=00=18=00=19=00=1A=00=1B=00=1C=00=1D=00=1E=00=1F=00 =00!=00"=00#=00$=00%=
=00&=00'=00*=00=00=00=00=06=00=00=00=06=FF=FF=00=10=00=00=00=00=00=E2=8E=C7=
=A6=02=0B=D0=01=00=00=00=03=00=00=00=00=0D=00=00=00=0D=FF=FF=00=11=00=00=00=
=00=00=E2=8E=C7=A6=02=0B=D2=01=00=00=00=01=00=03=00=00=01=00=00=00=00=00=00=
=06=00=00=00=06=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=02=0B=E0=01=00=00=00=
=04=00=00=00=01!=00=00=01!=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02=0B=E2=
=01=00=00=00=01=00=04=00=00pe=F6=85=E0P
=02=00=FF=FF=03=00=CA
=00=00=00=00=00thread=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=16=00=00=00=16=00=00=00=10=00=00=
=00=00=00=E2=8E=C7=A6=02=10=C9=01=00=00=00=11=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=0C=00=00=00=0C=00=00=00=11=00=00=00=00=00=E2=
=8E=C7=A6=02=10=D2=01=00=00=00=01=00=11=00=00=00=00=00=00=00=00=0D=00=00=00=
=0D=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=02=10=E7=01=00=00=004=00=00=00=
=00=00=00=00=00=00=00=00=10=00=00=00=10=00=00=00=11=00=00=00=00=00=E2=8E=C7=
=A6=02=10=EE=01=00=00=00=01=004=00=00=00=00=00=00=00=00=00=00=00=00=17=00=
=00=00=17=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=02=11=04=01=00=00=00/=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=0D=00=00=00=0D=
=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02=11=06=01=00=00=00=01=00/=00=00=CA
=00=00=00=00=00=06=00=00=00=06=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=02=11=
=1C=01=00=00=00I=00=00=00=003=00=00=003=00=00=00=11=00=00=00=00=00=E2=8E=C7=
=A6=02=11=1E=01=00=00=00=01=00I=00=00=02=00=D6I=B0=D1(=EB'=92=96F=C0B=B5=10=
=1Bg=00=00=00=00=04=00=13=ACB=02=DE=B3=EA=11s=C2H=A1=C0=15=02=00=00=00=00=
=00=00=17=00=00=00=17=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=02=114=01=00=
=00=00=10=00=FB4=9B_=80=00=00=80=00=10=00=00=00=18=00=00=00=00=00=00=0C=00=
=00=00=0C=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02=116=01=00=00=00=01=00=
=10=00=00=00=00=00=00=00=00=17=00=00=00=17=00=00=00=10=00=00=00=00=00=E2=8E=
=C7=A6=02=11N=01=00=00=00=10=00=FB4=9B_=80=00=00=80=00=10=00=00=01=18=00=00=
=00=00=00=00=0C=00=00=00=0C=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02=11P=
=01=00=00=00=01=00=10=00=00=00=00=00=00=00=00=17=00=00=00=17=00=00=00=10=00=
=00=00=00=00=E2=8E=C7=A6=02=11g=01=00=00=00=10=00=FB4=9B_=80=00=00=80=00=10=
=00=00
=18=00=00=00=00=00=00=0C=00=00=00=0C=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=
=02=11i=01=00=00=00=01=00=10=00=00=00=00=00=00=00=00=06=00=00=00=06=00=00=
=00=10=00=00=00=00=00=E2=8E=C7=A6=02=11=81=01=00=00=00=3D=00=00=00=00=11=00=
=00=00=11=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02=11=83=01=00=00=00=01=00=
=3D=00=00=FF=03=00=00=1F=1F=05=00=00=00=00=08=00=00=00=08=00=00=00=10=00=00=
=00=00=00=E2=8E=C7=A6=02=11=9B=01=00=00=00=0E=00=01=04=00=00=00=0C=00=00=00=
=0C=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02=11=9C=01=00=00=00=01=00=0E=00=
=00=00=00=00=00=00=00=17=00=00=00=17=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=
=02=11=B3=01=00=00=00=10=00=FB4=9B_=80=00=00=80=00=10=00=00=0E=11=00=00=00=
=00=00=00=0C=00=00=00=0C=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02=11=B5=01=
=00=00=00=01=00=10=00=00=00=00=00=00=00=00=17=00=00=00=17=00=00=00=10=00=00=
=00=00=00=E2=8E=C7=A6=02=11=CC=01=00=00=00=10=00=FB4=9B_=80=00=00=80=00=10=
=00=00=0C=11=00=00=00=00=00=00=0C=00=00=00=0C=00=00=00=11=00=00=00=00=00=E2=
=8E=C7=A6=02=11=CD=01=00=00=00=01=00=10=00=00=00=00=00=00=00=00=0D=00=00=00=
=0D=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=02=11=E4=01=00=00=00'=00=00=00=
=00=00=00=00=00=00=00=00=10=00=00=00=10=00=00=00=11=00=00=00=00=00=E2=8E=C7=
=A6=02=11=E7=01=00=00=00=01=00'=00=00=00=00=00=00=00=00=00=00=00=00=0E=00=
=00=00=0E=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=02=11=FE=01=00=00=003=00,=
=F2M=A1A,=00=01=00=00=00=15=00=00=00=15=00=00=00=11=00=00=00=00=00=E2=8E=C7=
=A6=02=12=02=01=00=00=00*=00,=F2M=A1A,=00=01=00=00=00=00=00=00=00=00=00=00=
=10=00=00=00=10=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02=12=04=01=00=00=00=
=01=003=00=00,=F2M=A1A,=00=00=00=00"=00=00=00"=00=00=00=10=00=00=00=00=00=
=E2=8E=C7=A6=02=12(=01=00=00=00=12=00=00=01=00,=F2M=A1A,=00=04M=B6=80=A6=F8=
=EA=1D=17=83R=0Ct=B1=A8*=F7=00=00=00=00	=00=00=00	=00=00=00=11=00=00=00=00=
=00=E2=8E=C7=A6=02=12,=01=00=00=00=01=00=12=00=00=00=00=00,=00=00=00,=00=00=
=00=10=00=00=00=00=00=E2=8E=C7=A6=02=12C=01=00=00=00=13=00=01=00psy=91=85=
=F1=02=00=01=10=A1C=D1=FD=EES=CE=A1=981=EDA=88:=A4=F9+~,G=B8=D5=0C]$\=00=00=
=00	=00=00=00	=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02=12D=01=00=00=00=01=
=00=13=00=00=00=00=00=08=00=00=00=08=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=
=02=12\=01=00=00=000=00=00=00=00=00=00	=00=00=00	=00=00=00=11=00=00=00=00=
=00=E2=8E=C7=A6=02=12^=01=00=00=00=01=000=00=00=00=00=00=17=00=00=00=17=00=
=00=00=10=00=00=00=00=00=E2=8E=C7=A6=02=12t=01=00=00=005=00=01=00psy=91=85=
=F1=02=06=00	=00,=00=D8=00=00=00=00	=00=00=00	=00=00=00=11=00=00=00=00=00=
=E2=8E=C7=A6=02=12v=01=00=00=00=01=005=00=00=00=00=00=0E=00=00=00=0E=00=00=
=00=10=00=00=00=00=00=E2=8E=C7=A6=02=12=8C=01=00=00=003=00psy=91=85=F1=02=
=02=00=00=00=15=00=00=00=15=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02=12=90=
=01=00=00=00*=00psy=91=85=F1=02=01=00=00=00=00=00=00=00=00=00=00=10=00=00=
=00=10=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02=12=91=01=00=00=00=01=003=
=00=00psy=91=85=F1=02=00=00=00=17=00=00=00=17=00=00=00=10=00=00=00=00=00=E2=
=8E=C7=A6=02=12=B4=01=00=00=00=10=00=FB4=9B_=80=00=00=80=00=10=00=00=00=12=
=00=00=00=00=00=00=0C=00=00=00=0C=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02=
=12=B6=01=00=00=00=01=00=10=00=00=00=00=00=00=00=00=0E=00=00=00=0E=00=00=00=
=10=00=00=00=00=00=E2=8E=C7=A6=02=12=CD=01=00=00=00(=00=02=00k=1DF=027=05=
=00=00=00	=00=00=00	=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02=12=CF=01=00=
=00=00=01=00(=00=00=00=00=00=08=00=00=00=08=00=00=00=10=00=00=00=00=00=E2=
=8E=C7=A6=02=12=E5=01=00=00=00=0E=00=01=04=00=00=00=0C=00=00=00=0C=00=00=00=
=11=00=00=00=00=00=E2=8E=C7=A6=02=12=E7=01=00=00=00=01=00=0E=00=00=00=00=00=
=00=00=01
=00=00=01
=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=02=12=FE=01=00=00=00=0F=00BlueZ 5.5=
5=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=01=0D=00=00=01=0D=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02=13=00=
=01=00=00=00=01=00=0F=00=00BlueZ 5.55=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00*=00=00=00*=00=00=00=10=00=
=00=00=00=00=E2=8E=C7=A6=02=13=1B=01=00=00=00F=00=02=00=01=BF=01=FB=9DN=F3=
=BC6=D8t=F59A8hL=02=A5=99=BA=E4=E1|=A6=18"=8E=07V=B4=E8_=01=00=00=00	=00=00=
=00	=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02=13=1D=01=00=00=00=01=00F=00=
=00=00=00=00=07=00=00=00=07=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=02=133=
=01=00=00=00=07=00=00=00=00=00=0D=00=00=00=0D=00=00=00=11=00=00=00=00=00=E2=
=8E=C7=A6=02=135=01=00=00=00=01=00=07=00=00=C0
=00=00=00=00=00=07=00=00=00=07=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=02%=
=0C=01=00=00=00=07=00=01=00=00=00=0D=00=00=00=0D=00=00=00=11=00=00=00=00=00=
=E2=8E=C7=A6=02%=15=01=00=00=00=01=00=07=00=00=C2
=00=00=00=00=00	=00=00=00	=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=02%.=01=
=00=00=00=06=00=01=00=00=00=00=00=0D=00=00=00=0D=00=00=00=11=00=00=00=00=00=
=E2=8E=C7=A6=02%0=01=00=00=00=01=00=06=00=00=CA
=00=00=00=00=00=11=00=00=00=11=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=024[=
=01=00=00=00P=00psy=91=85=F1=02=01=00=00=00=00=00=00=10=00=00=00=10=00=00=
=00=11=00=00=00=00=00=E2=8E=C7=A6=024f=01=00=00=00=01=00P=00=00psy=91=85=F1=
=02=00=00=00Z=00=00=00Z=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=02Xh=06=0Bbl=
uetoothd=00Endpoint registered: sender=3D:1.76 path=3D/MediaEndpoint/A2DPSo=
urce/VENDOR/LDAC=00=00=00=00\=00=00=00\=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=
=A6=02X=89=06=0Bbluetoothd=00Endpoint registered: sender=3D:1.76 path=3D/Me=
diaEndpoint/A2DPSource/VENDOR/APTXHD=00=00=00=00Z=00=00=00Z=FF=FF=00=0D=00=
=00=00=00=00=E2=8E=C7=A6=02X=94=06=0Bbluetoothd=00Endpoint registered: send=
er=3D:1.76 path=3D/MediaEndpoint/A2DPSource/VENDOR/APTX=00=00=00=00R=00=00=
=00R=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=02X=9D=06=0Bbluetoothd=00Endpoi=
nt registered: sender=3D:1.76 path=3D/MediaEndpoint/A2DPSource/AAC=00=00=00=
=00R=00=00=00R=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=02X=A6=06=0Bbluetooth=
d=00Endpoint registered: sender=3D:1.76 path=3D/MediaEndpoint/A2DPSource/SB=
C=00=00=00=00Z=00=00=00Z=FF=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=02X=D5=06=
=0Bbluetoothd=00Endpoint registered: sender=3D:1.76 path=3D/MediaEndpoint/A=
2DPSink/VENDOR/APTXHD=00=00=00=00X=00=00=00X=FF=FF=00=0D=00=00=00=00=00=E2=
=8E=C7=A6=02X=EB=06=0Bbluetoothd=00Endpoint registered: sender=3D:1.76 path=
=3D/MediaEndpoint/A2DPSink/VENDOR/APTX=00=00=00=00P=00=00=00P=FF=FF=00=0D=
=00=00=00=00=00=E2=8E=C7=A6=02Y=01=06=0Bbluetoothd=00Endpoint registered: s=
ender=3D:1.76 path=3D/MediaEndpoint/A2DPSink/AAC=00=00=00=00P=00=00=00P=FF=
=FF=00=0D=00=00=00=00=00=E2=8E=C7=A6=02Y=18=06=0Bbluetoothd=00Endpoint regi=
stered: sender=3D:1.76 path=3D/MediaEndpoint/A2DPSink/SBC=00=00=00=00=17=00=
=00=00=17=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=02Y=E4=01=00=00=00=10=00=
=FB4=9B_=80=00=00=80=00=10=00=00
=11=00=00=08=00=00=00=0C=00=00=00=0C=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=
=02Y=EB=01=00=00=00=01=00=10=00=00=00=00=00=00=00=00=17=00=00=00=17=00=00=
=00=10=00=00=00=00=00=E2=8E=C7=A6=02Z=05=01=00=00=00=10=00=FB4=9B_=80=00=00=
=80=00=10=00=00=0B=11=00=00=04=00=00=00=0C=00=00=00=0C=00=00=00=11=00=00=00=
=00=00=E2=8E=C7=A6=02Z=06=01=00=00=00=01=00=10=00=00=00=00=00=00=00=00=17=
=00=00=00=17=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=02Z=1C=01=00=00=00=10=
=00=FB4=9B_=80=00=00=80=00=10=00=00=12=11=00=00=00=00=00=00=0C=00=00=00=0C=
=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02Z=1E=01=00=00=00=01=00=10=00=00=
=00=00=00=00=00=00=17=00=00=00=17=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=02=
Z7=01=00=00=00=10=00=FB4=9B_=80=00=00=80=00=10=00=00=08=11=00=00 =00=00=00=
=0C=00=00=00=0C=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=02Z9=01=00=00=00=01=
=00=10=00=00=00=00=00=00=00=01
=00=00=01
=00=00=00=10=00=00=00=00=00=E2=8E=C7=A6=05f=00=01=00=00=00=0F=00thread=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=01=0D=00=00=01=0D=00=00=00=11=00=00=00=00=00=E2=8E=C7=A6=05=
f=0C=01=00=00=00=01=00=0F=00=00thread=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00=00
--wac7ysb48OaltWcw--
