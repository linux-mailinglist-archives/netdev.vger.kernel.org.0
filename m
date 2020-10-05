Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E10283C28
	for <lists+netdev@lfdr.de>; Mon,  5 Oct 2020 18:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728130AbgJEQMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Oct 2020 12:12:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbgJEQMX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Oct 2020 12:12:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B667206DD;
        Mon,  5 Oct 2020 16:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601914342;
        bh=pdHlQPz4mf002rX/QtQTAU1eLyO9isayy4TZRHcdJHw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h4cGT7Uv6gSipm8mwKa55HNx0Ros9ACxIc+3wwDIV1Qiz/pgBf43MR+mvHU3MGtZU
         wyjmk08uGJ+rF1LoaA6D2mS1zWiaNQ5aoVcNTnhAVLfPq6LpcJaeA2MvktJ5bRHj8b
         qVJrDQVXPuEKhDFhRqzu3NB4eKLq87TLQgvCbTm8=
Date:   Mon, 5 Oct 2020 18:11:49 +0200
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
Message-ID: <20201005161149.GA2378402@kroah.com>
References: <20201003135449.GA2691@kroah.com>
 <A1C95238-CBCB-4FD4-B46D-A62AED0C77E5@holtmann.org>
 <20201003160713.GA1512229@kroah.com>
 <AABC2831-4E88-41A2-8A20-1BFC88895686@holtmann.org>
 <20201004105124.GA2429@kroah.com>
 <3F7BDD50-DEA3-4CB0-A9A0-69E7EE2923D5@holtmann.org>
 <20201005083624.GA2442@kroah.com>
 <220D3B4E-D73E-43AD-8FF8-887D1A628235@holtmann.org>
 <20201005124018.GA800868@kroah.com>
 <824BC92C-5035-4B80-80E7-298508E4ADD7@holtmann.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
In-Reply-To: <824BC92C-5035-4B80-80E7-298508E4ADD7@holtmann.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 05, 2020 at 05:44:48PM +0200, Marcel Holtmann wrote:
> Hi Greg,
> 
> >>>>>>>>> This reverts commit 0eee35bdfa3b472cc986ecc6ad76293fdcda59e2 as it
> >>>>>>>>> breaks all bluetooth connections on my machine.
> >>>>>>>>> 
> >>>>>>>>> Cc: Marcel Holtmann <marcel@holtmann.org>
> >>>>>>>>> Cc: Sathish Narsimman <sathish.narasimman@intel.com>
> >>>>>>>>> Fixes: 0eee35bdfa3b ("Bluetooth: Update resolving list when updating whitelist")
> >>>>>>>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >>>>>>>>> ---
> >>>>>>>>> net/bluetooth/hci_request.c | 41 ++-----------------------------------
> >>>>>>>>> 1 file changed, 2 insertions(+), 39 deletions(-)
> >>>>>>>>> 
> >>>>>>>>> This has been bugging me for since 5.9-rc1, when all bluetooth devices
> >>>>>>>>> stopped working on my desktop system.  I finally got the time to do
> >>>>>>>>> bisection today, and it came down to this patch.  Reverting it on top of
> >>>>>>>>> 5.9-rc7 restored bluetooth devices and now my input devices properly
> >>>>>>>>> work.
> >>>>>>>>> 
> >>>>>>>>> As it's almost 5.9-final, any chance this can be merged now to fix the
> >>>>>>>>> issue?
> >>>>>>>> 
> >>>>>>>> can you be specific what breaks since our guys and I also think the
> >>>>>>>> ChromeOS guys have been testing these series of patches heavily.
> >>>>>>> 
> >>>>>>> My bluetooth trackball does not connect at all.  With this reverted, it
> >>>>>>> all "just works".
> >>>>>>> 
> >>>>>>> Same I think for a Bluetooth headset, can check that again if you really
> >>>>>>> need me to, but the trackball is reliable here.
> >>>>>>> 
> >>>>>>>> When you run btmon does it indicate any errors?
> >>>>>>> 
> >>>>>>> How do I run it and where are the errors displayed?
> >>>>>> 
> >>>>>> you can do btmon -w trace.log and just let it run like tcdpump.
> >>>>> 
> >>>>> Ok, attached.
> >>>>> 
> >>>>> The device is not connecting, and then I open the gnome bluetooth dialog
> >>>>> and it scans for devices in the area, but does not connect to my
> >>>>> existing devices at all.
> >>>>> 
> >>>>> Any ideas?
> >>>> 
> >>>> the trace file is from -rc7 or from -rc7 with this patch reverted?
> >>>> 
> >>>> I asked, because I see no hint that anything goes wrong. However I have a suspicion if you bisected it to this patch.
> >>>> 
> >>>> diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
> >>>> index e0269192f2e5..94c0daa9f28d 100644
> >>>> --- a/net/bluetooth/hci_request.c
> >>>> +++ b/net/bluetooth/hci_request.c
> >>>> @@ -732,7 +732,7 @@ static int add_to_white_list(struct hci_request *req,
> >>>>               return -1;
> >>>> 
> >>>>       /* White list can not be used with RPAs */
> >>>> -       if (!allow_rpa && !use_ll_privacy(hdev) &&
> >>>> +       if (!allow_rpa &&
> >>>>           hci_find_irk_by_addr(hdev, &params->addr, params->addr_type)) {
> >>>>               return -1;
> >>>>       }
> >>>> @@ -812,7 +812,7 @@ static u8 update_white_list(struct hci_request *req)
> >>>>               }
> >>>> 
> >>>>               /* White list can not be used with RPAs */
> >>>> -               if (!allow_rpa && !use_ll_privacy(hdev) &&
> >>>> +               if (!allow_rpa &&
> >>>>                   hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type)) {
> >>>>                       return 0x00;
> >>>>               }
> >>>> 
> >>>> 
> >>>> If you just do the above, does thing work for you again?
> >>> 
> >>> Corrupted white-space issues aside, yes, it works!
> >> 
> >> I just pasted it from a different terminal ;)
> >> 
> >>> I am running 5.9-rc8 with just this change on it and my tracball works
> >>> just fine.
> >>> 
> >>>> My suspicion is that the use_ll_privacy check is the wrong one here. It only checks if hardware feature is available, not if it is also enabled.
> >>> 
> >>> How would one go about enabling such a hardware feature if they wanted
> >>> to?  :)
> >> 
> >> I need to understand what is going wrong for you. I have a suspicion,
> >> but first I need to understand what kind of device you have. I hope
> >> the trace file is enough.
> > 
> > If you need any other information, just let me know, this is a USB
> > Bluetooth controller from Intel:
> > 
> > 	$ lsusb | grep Blue
> > 	Bus 009 Device 002: ID 8087:0029 Intel Corp. AX200 Bluetooth
> > 
> > And the output of usb-devices for it:
> > 	T:  Bus=09 Lev=01 Prnt=01 Port=04 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
> > 	D:  Ver= 2.01 Cls=e0(wlcon) Sub=01 Prot=01 MxPS=64 #Cfgs=  1
> > 	P:  Vendor=8087 ProdID=0029 Rev=00.01
> > 	C:  #Ifs= 2 Cfg#= 1 Atr=e0 MxPwr=100mA
> > 	I:  If#=0x0 Alt= 0 #EPs= 3 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> > 	I:  If#=0x1 Alt= 0 #EPs= 2 Cls=e0(wlcon) Sub=01 Prot=01 Driver=btusb
> 
> I already figured out that it is one of our controllers. The trace file gives it away.
> 
> So my suspicion is that the device you want to connect to uses RPA (aka random addresses). And we added support for resolving them in the firmware. Your hardware does support that, but the host side is not fully utilizing it and thus your device is filtered out.

Dude, get an email client that line-wraps :)

> If I am not mistaken, then the use_ll_privacy() check in these two specific places need to be replaced with LL Privacy Enabled check. And then the allow_rpa condition will do its job as expected.
> 
> We can confirm this if you send me a trace with the patch applied.

Want me to disconnect the device and then reconnect it using
bluetootctl?  I'll go do that now...

Ok, it's attached, I did:

$ bluetoothctl disconnect F1:85:91:79:73:70
Attempting to disconnect from F1:85:91:79:73:70
[CHG] Device F1:85:91:79:73:70 ServicesResolved: no
Successful disconnected

And then the gnome bluetooth daemon (or whatever it has) reconnected it
automatically, so you can see the connection happen, and some movements
in the log.

If there's anything else you need, just let me know.

thanks,

greg k-h

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="trace-disconnect-connect.log"
Content-Transfer-Encoding: quoted-printable

btsnoop=00=00=00=00=01=00=00=07=D1=00=00=00'=00=00=00'=FF=FF=00=0C=00=00=00=
=00=00=E2=8E=A1=C7o=E5=DALinux version 5.9.0-rc8-dirty (x86_64)=00=00=00=00=
!=00=00=00!=FF=FF=00=0C=00=00=00=00=00=E2=8E=A1=C7o=E5=DDBluetooth subsyste=
m version 2.22=00=00=00=00=10=00=00=00=10=00=00=00=00=00=00=00=00=00=E2=8E=
=A1=C7o=E5=DE=00=01pe=F6=85=E0Phci0=00=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=08=00=00=00=00=00=E2=8E=A1=C7o=E5=DF=00=00=00=08=00=00=00=08=00=00=00
=00=00=00=00=00=E2=8E=A1=C7o=E5=DFpe=F6=85=E0P=02=00=00=00=00=1E=00=00=00=
=1E=FF=FF=00=0E=00=00=00=00=00=E2=8E=A1=C7o=E5=E0=01=00=00=00=02=00=01=12=
=00=01=00=00=00=10bluetoothd=00=00=00=00=00=00=00=00=00=0D=00=00=00=0D=00=
=00=00=10=00=00=00=00=00=E2=8E=A1=C7=C2=B1=FD=01=00=00=00=14=00psy=91=85=F1=
=02=00=00=00=06=00=00=00=06=00=00=00=02=00=00=00=00=00=E2=8E=A1=C7=C2=B2=3D=
=06=04=03=01=0E=13=00=00=00=06=00=00=00=06=00=00=00=03=00=00=00=00=00=E2=8E=
=A1=C7=C4=87>=0F=04=00=01=06=04=00=00=00=06=00=00=00=06=00=00=00=03=00=00=
=00=00=00=E2=8E=A1=C7=C8}B=05=04=00=01=0E=16=00=00=00=10=00=00=00=10=00=00=
=00=11=00=00=00=00=00=E2=8E=A1=C7=C8}q=01=00=00=00=01=00=14=00=00psy=91=85=
=F1=02=00=00=00=0B=00=00=00=0B=00=00=00=02=00=00=00=00=00=E2=8E=A1=C7=C9=B3=
BA =08=00=00=01=00`=000=00=00=00=00=06=00=00=00=06=00=00=00=03=00=00=00=00=
=00=E2=8E=A1=C7=C9=BE=B0=0E=04=01A =00=00=00=00	=00=00=00	=00=00=00=02=00=
=00=00=00=00=E2=8E=A1=C7=C9=BE=C7B =06=01=01=00=00=00=00=00=00=00=06=00=00=
=00=06=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=C9=CE=C0=0E=04=02B =00=00=00=
=005=00=00=005=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=CA@=82>3=0D=01=13=00=
=00=C1=A2!=0ElT=01=00=FF=7F=A9=00=00=00=00=00=00=00=00=00=19=02=01=12=05=02=
&=18=14=18=0F	MyRun 18004074=00=00=008=00=00=008=00=00=00=03=00=00=00=00=00=
=E2=8E=A1=C7=CAY/>6=0D=01=12=00=01=0B=D2=B4=E8=C5X=01=00=FF=7F=AB=00=00=00=
=00=00=00=00=00=00=1C=03=03o=FD=17=16o=FD>=E2w&=F1=BEg=B6=EFe=BAP=C7=F5=91j=
=0B=3D=E6=B9=00=00=007=00=00=007=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=CAt=
=9C>5=0D=01=12=00=00=18=B9=1A=ADk=A8=01=00=FF=7F=A1=00=00=00=00=00=00=00=00=
=00=1B=1A=FFL=00=02=15Pv\=B7=D9=EAN!=99=A4=FA=87=96=13=A4=92{=AFC=D5=CE=00=
=00=00.=00=00=00.=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=CC=1Ak>,=0D=01=13=
=00=01+S=C2nPU=01=00=FF=7F=A1=00=00=00=00=00=00=00=00=00=12=02=01=1A=02
=0C=0B=FFL=00=10=06=11=1E=C7=91f=E2=00=00=00.=00=00=00.=00=00=00=03=00=00=
=00=00=00=E2=8E=A1=C7=CC=BA=91>,=0D=01=13=00=01=ACo3q=B5f=01=00=FF=7F=AF=00=
=00=00=00=00=00=00=00=00=12=02=01=1A=02
=07=0B=FFL=00=10=06<=1EIc=07=F5=00=00=008=00=00=008=00=00=00=03=00=00=00=00=
=00=E2=8E=A1=C7=CD=16b>6=0D=01=13=00=00=04=A7=CF=DAc=E0=01=00=FF=7F=BA=00=
=00=00=00=00=00=00=00=00=1C=11=06>=D9=F5.=B7=F1?=BC=80EK3=F6l=81&	=16*%=E0c=
=DA=CF=A6=F9=00=00=008=00=00=008=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=CD=
=BCh>6=0D=01=12=00=01h=D7)nZs=01=00=FF=7F=A4=00=00=00=00=00=00=00=00=00=1C=
=03=03=9F=FE=17=16=9F=FE=02fM4Wt-UVwuA=00=00=01t=F9=86=E1|=00=00=00&=00=00=
=00&=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=CF=D3v>$=0D=01=10=00=01=183=97C=
=A87=01=00=FF=7F=A4=00=00=00=00=00=00=00=00=00
=02=01=1A=06=FFL=00
=01=00=00=00=00-=00=00=00-=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=D2JO>+=0D=
=01=13=00=013=07=B8=85;n=01=00=FF=7F=A0=00=00=00=00=00=00=00=00=00=11=02=01=
=1A=02
=0C
=FFL=00=10=05=03=1CE=F3=DA=00=00=00;=00=00=00;=00=00=00=03=00=00=00=00=00=
=E2=8E=A1=C7=D2R=10>9=0D=01=10=00=01=92=88=00=1B=AC=00=01=00=FF=7F=AF=00=00=
=00=00=00=00=00=00=00=1F=02=01=1A=03=03o=FD=17=16o=FD=8B$=8F=FF=CC=85=991JM=
=A8a=1C=8690=FEN}=FB=00=00=00;=00=00=00;=00=00=00=03=00=00=00=00=00=E2=8E=
=A1=C7=D2Y=E0>9=0D=01=10=00=01=06=C6=83=F2=9CF=01=00=FF=7F=A2=00=00=00=00=
=00=00=00=00=00=1F=1E=FF=06=00=01	 =02'=F3=A0=ECw=D3e=0Fb=9D=93=F2%=F6UD=88=
9=00Q4=AB=E0=00=00=00;=00=00=00;=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=D5B=
=1A>9=0D=01=10=00=01"=17N=CA=A4+=01=00=FF=7F=A2=00=00=00=00=00=00=00=00=00=
=1F=1E=FF=06=00=01	 =02w=FE.=A2=D2C[=F3=C4{=87=F7=A0|=C5Z=ADr:=E6=18=B4m=00=
=00=00-=00=00=00-=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=D9za>+=0D=01=13=00=
=01=D5=13=DF7=E7q=01=00=FF=7F=A0=00=00=00=00=00=00=00=00=00=11=02=01=1A=02
=0C
=FFL=00=10=05W=18=B7=DB	=00=00=00-=00=00=00-=00=00=00=03=00=00=00=00=00=E2=
=8E=A1=C7=E0=19=C7>+=0D=01=13=00=01y{=81"=1CU=01=00=FF=7F=A5=00=00=00=00=00=
=00=00=00=00=11=02=01=1A=02
=0C
=FFL=00=10=05=1B=1C=FB;=E7=00=00=00%=00=00=00%=00=00=00=03=00=00=00=00=00=
=E2=8E=A1=C7=F2A=A4>#=0D=01=13=00=00=1EIx=19=99=F0=01=00=FF=7F=A6=00=00=00=
=00=00=00=00=00=00	=02=01=06=05=FF=87=00=0C=99=00=00=00=1C=00=00=00=1C=00=
=00=00=03=00=00=00=00=00=E2=8E=A1=C7=F3b=97>=1A=0D=01=15=00=01psy=91=85=F1=
=01=00=FF=7F=BC=00=00=00pe=F6=85=E0P=00=00=00=00	=00=00=00	=00=00=00=02=00=
=00=00=00=00=E2=8E=A1=C7=F3b=C5B =06=00=00=00=00=00=00=00=00=00=06=00=00=00=
=06=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=F3n:=0E=04=02B =00=00=00=00=1D=
=00=00=00=1D=00=00=00=02=00=00=00=00=00=E2=8E=A1=C7=F3naC =1A=00=00=01psy=
=91=85=F1=01`=00`=00=06=00	=00,=00=D8=00=00=00=00=00=00=00=00=06=00=00=00=
=06=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=F3}=DA=0F=04=00=02C =00=00=00!=
=00=00=00!=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=F3=99H>=1F
=00=01=0E=00=01psy=91=85=F1=00=00=00=00=00=00=00=00=00=00=00=00=06=00,=00=
=D8=00=00=00=00=00=13=00=00=00=13=00=00=00=11=00=00=00=00=00=E2=8E=A1=C7=F3=
=99h=01=00=00=00=0B=00psy=91=85=F1=02=00=00=00=00=00=00=00=00=00=05=00=00=
=00=05=00=00=00=02=00=00=00=00=00=E2=8E=A1=C7=F3=99=B4=16 =02=01=0E=00=00=
=00=06=00=00=00=06=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=F3=A1=02>=04=14=
=01=0E=00=00=00=00=06=00=00=00=06=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=F3=
=A4=EA=0F=04=00=01=16 =00=00=00=0E=00=00=00=0E=00=00=00=03=00=00=00=00=00=
=E2=8E=A1=C7=F3=D7=BB>=0C=04=00=01=0E=01=00=00=00=00=00=00=00=00=00=00=1F=
=00=00=00=1F=00=00=00=02=00=00=00=00=00=E2=8E=A1=C7=F3=D80=19 =1C=01=0E=D1=
=FD=EES=CE=A1=981=A1C=EDA=88:=A4=F9+~,G=B8=D5=0C]$\=00=00=00=06=00=00=00=06=
=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=F3=E3i=0F=04=00=01=19 =00=00=00=06=
=00=00=00=06=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=F4=FC=AD=08=04=00=01=0E=
=01=00=00=00=07=00=00=00=07=00=00=00=02=00=00=00=00=00=E2=8E=A1=C7=F4=FC=D8=
|=0C=04=01=0E=B8=0B=00=00=00=0B=00=00=00=0B=00=00=00=04=00=00=00=00=00=E2=
=8E=A1=C7=F4=FD=01=01=0E=07=00=03=00=04=00=02=05=02=00=00=00=08=00=00=00=08=
=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=F5=08`=0E=06=01|=0C=00=01=0E=00=00=
=00=1E=00=00=00=1E=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F5=192=01.=1A=00=
=16=00=04=00=1B+=00=FF=04=00=01=01=01=00=00=00=00=00=00=00=00=00=00=00=00=
=00=00=00=00=07=00=00=00=07=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=F5=1B=E7=
=13=05=01=01=0E=01=00=00=00=00=12=00=00=00=12=00=00=00=05=00=00=00=00=00=E2=
=8E=A1=C7=F55=AC=01.=0E=00
=00=04=00=1B'=00=00=00=04=F0=FF=00=00=00=00=00=0B=00=00=00=0B=00=00=00=05=
=00=00=00=00=00=E2=8E=A1=C7=F57=B2=01.=07=00=03=00=04=00=03=17=00=00=00=00=
=0B=00=00=00=0B=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=F58=DA=01=0E=07=00=
=03=00=04=00
=1D=00=00=00=00=12=00=00=00=12=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F5S=
=CD=01.=0E=00
=00=04=00=1B'=00=00=004=F0=FF=00=00=00=00=00=07=00=00=00=07=00=00=00=03=00=
=00=00=00=00=E2=8E=A1=C7=F5V=7F=13=05=01=01=0E=01=00=00=00=00
=00=00=00
=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F5=8DF=01.=06=00=02=00=04=00=0Bd=00=
=00=00=0B=00=00=00=0B=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=F5=8D=AC=01=0E=
=07=00=03=00=04=00
=1A=00=00=00=00=12=00=00=00=12=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F5=8F=
=94=01.=0E=00
=00=04=00=1B'=00=00=00=07=10=00=00=00=00=00=00=12=00=00=00=12=00=00=00=05=
=00=00=00=00=00=E2=8E=A1=C7=F5=AB=B2=01.=0E=00
=00=04=00=1B'=00=00=00=04=00=00=00=00=00=00=00=07=00=00=00=07=00=00=00=03=
=00=00=00=00=00=E2=8E=A1=C7=F5=ACn=13=05=01=01=0E=01=00=00=00=00=10=00=00=
=00=10=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F5=C8=10=01.=0C=00=08=00=04=
=00=0B=02m=04=1D=B0"=00=00=00=00=0B=00=00=00=0B=00=00=00=04=00=00=00=00=00=
=E2=8E=A1=C7=F5=C8^=01=0E=07=00=03=00=04=00
=03=00=00=00=00=12=00=00=00=12=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F5=CA=
Z=01.=0E=00
=00=04=00=1B'=00=00=00=07=10=00=00=00=00=00=00=12=00=00=00=12=00=00=00=05=
=00=00=00=00=00=E2=8E=A1=C7=F5=E6K=01.=0E=00
=00=04=00=1B'=00=00=00=02=10=00=00=00=00=00=00=07=00=00=00=07=00=00=00=03=
=00=00=00=00=00=E2=8E=A1=C7=F5=E6=F6=13=05=01=01=0E=01=00=00=00=00=10=00=00=
=00=10=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F6=02=A8=01.=0C=00=08=00=04=
=00=0BMX Ergo=00=00=00=0B=00=00=00=0B=00=00=00=04=00=00=00=00=00=E2=8E=A1=
=C7=F6=02=F6=01=0E=07=00=03=00=04=00
=05=00=00=00=00=12=00=00=00=12=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F6=04=
=F1=01.=0E=00
=00=04=00=1B'=00=00=00=02=10=00=00=00=00=00=00=12=00=00=00=12=00=00=00=05=
=00=00=00=00=00=E2=8E=A1=C7=F6 =E2=01.=0E=00
=00=04=00=1B'=00=00=00=01=00=00=00=00=00=00=00=07=00=00=00=07=00=00=00=03=
=00=00=00=00=00=E2=8E=A1=C7=F6!=90=13=05=01=01=0E=01=00=00=00=00=0B=00=00=
=00=0B=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F6=3D=19=01.=07=00=03=00=04=
=00=0B=C2=03=00=00=00=0B=00=00=00=0B=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=
=F6=3De=01=0E=07=00=03=00=04=00
 =00=00=00=00=12=00=00=00=12=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F6?b=01=
=2E=0E=00
=00=04=00=1B'=00=00=00=01=00=00=00=00=00=00=00=07=00=00=00=07=00=00=00=03=
=00=00=00=00=00=E2=8E=A1=C7=F6\6=13=05=01=01=0E=01=00=00=00=00=0D=00=00=00=
=0D=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F6w=BD=01.	=00=05=00=04=00=0B=11=
=01=00=03=00=00=00=0B=00=00=00=0B=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=F6=
x=0B=01=0E=07=00=03=00=04=00
%=00=00=00=00=12=00=00=00=12=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F6z=07=
=01.=0E=00
=00=04=00=1B'=00=00=00=00=F0=FF=00=00=00=00=00=12=00=00=00=12=00=00=00=05=
=00=00=00=00=00=E2=8E=A1=C7=F6=96=10=01.=0E=00
=00=04=00=1B'=00=00=00=FF=EF=FF=00=00=00=00=00=07=00=00=00=07=00=00=00=03=
=00=00=00=00=00=E2=8E=A1=C7=F6=96=CC=13=05=01=01=0E=01=00=00=00=00=1F=00=00=
=00=1F=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F6=B2=E2=01.=1B=00=17=00=04=
=00=0B=05=01	=02=A1=01=85=02	=01=A1=00=95=10u=01=15=00%=01=05	=00=00=00=0B=
=00=00=00=0B=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=F6=B30=01=0E=07=00=03=
=00=04=00
)=00=00=00=00=12=00=00=00=12=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F6=D0=
=AE=01.=0E=00
=00=04=00=1B'=00=00=00=00=E0=FF=00=00=00=00=00=07=00=00=00=07=00=00=00=03=
=00=00=00=00=00=E2=8E=A1=C7=F6=D1T=13=05=01=01=0E=01=00=00=00=00=0B=00=00=
=00=0B=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F6=EC=DF=01.=07=00=03=00=04=
=00=0B=02=01=00=00=00=0B=00=00=00=0B=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=
=F6=ED-=01=0E=07=00=03=00=04=00
-=00=00=00=00=12=00=00=00=12=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F6=EF*=
=01.=0E=00
=00=04=00=1B'=00=00=00=00=E0=FF=00=00=00=00=00=07=00=00=00=07=00=00=00=03=
=00=00=00=00=00=E2=8E=A1=C7=F7=0B=FB=13=05=01=01=0E=01=00=00=00=00=0B=00=00=
=00=0B=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F7'e=01.=07=00=03=00=04=00=0B=
=11=01=00=00=00=0B=00=00=00=0B=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=F7'=
=B3=01=0E=07=00=03=00=04=00
0=00=00=00=00=07=00=00=00=07=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=F7F=93=
=13=05=01=01=0E=01=00=00=00=00=0B=00=00=00=0B=00=00=00=05=00=00=00=00=00=E2=
=8E=A1=C7=F7a=FD=01.=07=00=03=00=04=00=0B=11=02=00=00=00=0B=00=00=00=0B=00=
=00=00=04=00=00=00=00=00=E2=8E=A1=C7=F7bJ=01=0E=07=00=03=00=04=00
4=00=00=00=00=07=00=00=00=07=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=F7=81*=
=13=05=01=01=0E=01=00=00=00=00
=00=00=00
=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F7=9C=8E=01.=06=00=02=00=04=00=0B=
=01=00=00=00=0F=00=00=00=0F=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=F7=9C=DB=
=01=0E=0B=00=07=00=04=00=08=01=00=FF=FF:+=00=00=00=07=00=00=00=07=00=00=00=
=03=00=00=00=00=00=E2=8E=A1=C7=F7=BB=C2=13=05=01=01=0E=01=00=00=00=00=0D=00=
=00=00=0D=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F7=D7@=01.	=00=05=00=04=00=
=01=08=01=00
=00=00=00=0F=00=00=00=0F=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=F7=D7=8F=01=
=0E=0B=00=07=00=04=00=10=01=00=FF=FF=00(=00=00=00=07=00=00=00=07=00=00=00=
=03=00=00=00=00=00=E2=8E=A1=C7=F7=F6Z=13=05=01=01=0E=01=00=00=00=00=1C=00=
=00=00=1C=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F8=12U=01.=18=00=14=00=04=
=00=11=06=01=00=07=00=00=18=08=00=0B=00=01=18=0C=00=1A=00
=18=00=00=00=0D=00=00=00=0D=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=F8=12=A3=
=01=0E	=00=05=00=04=00=0C%=00=16=00=00=00=00=07=00=00=00=07=00=00=00=03=00=
=00=00=00=00=E2=8E=A1=C7=F80=F1=13=05=01=01=0E=01=00=00=00=00=1F=00=00=00=
=1F=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F8M=08=01.=1B=00=17=00=04=00=0D=
=19=01)=10=81=02=05=01=16=01=F8&=FF=07u=0C=95=02	0	1=00=00=00=0B=00=00=00=
=0B=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=F8MW=01=0E=07=00=03=00=04=00
(=00=00=00=00=07=00=00=00=07=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=F8k=89=
=13=05=01=01=0E=01=00=00=00=00=0B=00=00=00=0B=00=00=00=05=00=00=00=00=00=E2=
=8E=A1=C7=F8=86=F2=01.=07=00=03=00=04=00=0B=01=00=00=00=00=0B=00=00=00=0B=
=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=F8=87B=01=0E=07=00=03=00=04=00
,=00=00=00=00=07=00=00=00=07=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=F8=A6"=
=13=05=01=01=0E=01=00=00=00=00=0B=00=00=00=0B=00=00=00=05=00=00=00=00=00=E2=
=8E=A1=C7=F8=C1=8A=01.=07=00=03=00=04=00=0B=01=00=00=00=00=0F=00=00=00=0F=
=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=F8=C1=D7=01=0E=0B=00=07=00=04=00=10=
=1B=00=FF=FF=00(=00=00=00=07=00=00=00=07=00=00=00=03=00=00=00=00=00=E2=8E=
=A1=C7=F8=E0=B8=13=05=01=01=0E=01=00=00=00=00=16=00=00=00=16=00=00=00=05=00=
=00=00=00=00=E2=8E=A1=C7=F8=FC=81=01.=12=00=0E=00=04=00=11=06=1B=00=1D=00=
=0F=18=1E=004=00=12=18=00=00=00=0D=00=00=00=0D=00=00=00=04=00=00=00=00=00=
=E2=8E=A1=C7=F8=FC=CE=01=0E	=00=05=00=04=00=0C%=00,=00=00=00=00=07=00=00=00=
=07=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=F9=1BP=13=05=01=01=0E=01=00=00=
=00=00=1F=00=00=00=1F=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F97g=01.=1B=00=
=17=00=04=00=0D=81=06=15=81%=7Fu=08=95=01	8=81=06=95=01=05=0C
8=02=81=00=00=00=0D=00=00=00=0D=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=F97=
=B5=01=0E	=00=05=00=04=00=12(=00=01=00=00=00=00=07=00=00=00=07=00=00=00=03=
=00=00=00=00=00=E2=8E=A1=C7=F9U=E7=13=05=01=01=0E=01=00=00=00=00	=00=00=00	=
=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=F9qI=01.=05=00=01=00=04=00=13=00=00=
=00=0D=00=00=00=0D=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=F9q=96=01=0E	=00=
=05=00=04=00=12,=00=01=00=00=00=00=07=00=00=00=07=00=00=00=03=00=00=00=00=
=00=E2=8E=A1=C7=F9=90~=13=05=01=01=0E=01=00=00=00=00	=00=00=00	=00=00=00=05=
=00=00=00=00=00=E2=8E=A1=C7=F9=AB=E2=01.=05=00=01=00=04=00=13=00=00=00=0F=
=00=00=00=0F=00=00=00=04=00=00=00=00=00=E2=8E=A1=C7=F9=AC0=01=0E=0B=00=07=
=00=04=00=105=00=FF=FF=00(=00=00=00=07=00=00=00=07=00=00=00=03=00=00=00=00=
=00=E2=8E=A1=C7=F9=CB=16=13=05=01=01=0E=01=00=00=00=00=1E=00=00=00=1E=00=00=
=00=05=00=00=00=00=00=E2=8E=A1=C7=F9=E7%=01.=1A=00=16=00=04=00=11=145=00=FF=
=FFm=04=00 =1F=01=00=80=00=10=00=00=00=00=01=00=00=00=00=0D=00=00=00=0D=00=
=00=00=04=00=00=00=00=00=E2=8E=A1=C7=FA=0F=96=01=0E	=00=05=00=04=00=0C%=00B=
=00=00=00=00=07=00=00=00=07=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=FF.=08=
=13=05=01=01=0E=01=00=00=00=00=1F=00=00=00=1F=00=00=00=05=00=00=00=00=00=E2=
=8E=A1=C7=FFH=1D=01.=1B=00=17=00=04=00=0D=06=C0=C0=06C=FF
=02=02=A1=01=85=11u=08=95=13=15=00&=FF=00=00=00=00=0D=00=00=00=0D=00=00=00=
=04=00=00=00=00=00=E2=8E=A1=C7=FFH=9E=01=0E	=00=05=00=04=00=12=0B=00=02=00=
=00=00=00=07=00=00=00=07=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=FFh=93=13=
=05=01=01=0E=01=00=00=00=00	=00=00=00	=00=00=00=05=00=00=00=00=00=E2=8E=A1=
=C7=FF=81=F3=01.=05=00=01=00=04=00=13=00=00=00=0D=00=00=00=0D=00=00=00=04=
=00=00=00=00=00=E2=8E=A1=C7=FF=82E=01=0E	=00=05=00=04=00=0C%=00X=00=00=00=
=00=07=00=00=00=07=00=00=00=03=00=00=00=00=00=E2=8E=A1=C7=FF=A3%=13=05=01=
=01=0E=01=00=00=00=00=12=00=00=00=12=00=00=00=05=00=00=00=00=00=E2=8E=A1=C7=
=FF=BC=D7=01.=0E=00
=00=04=00=0D	=02=81=00	=02=91=00=C0
--OXfL5xGRrasGEqWY--
