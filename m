Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27B2D27A73F
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 08:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgI1GJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 02:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgI1GJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 02:09:36 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2895EC0613CF
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 23:09:36 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id q9so5493487wmj.2
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 23:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rDQBnwudsy0mOdm938z9L6vGjeDLOfM2yyPO6zyCRA4=;
        b=SZSYW1sOaya84+FoqIF06ha9N8ODzEi30tB3Whv6kAMRkPdbr98iqbTY7KyHJVxU8V
         uFunGHgQBcadvUurMaapr3yKX2sc0KtcDPcLHg/vQz1w6CJk8ZOalI6VgDPGEwMt47nq
         kvabX2xXjIpQn4YxB3n+AkQjdpWBv8pCh1ls1URToDWoor/+vbA4x/vRZE6dmP1CJbd1
         CI1Sk6TVdg9xN+VAXWABkIzkv2hCR0es5YH3vDSwB7msBiE9UFzF0miOrTpaDxVcX2K7
         GfZChw6mxie/zceDNlNJnn8DbstOSGL/63wBwEpzpcvPy+we9M3xhz6pYnkLo3laCA3o
         /6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rDQBnwudsy0mOdm938z9L6vGjeDLOfM2yyPO6zyCRA4=;
        b=rI1Mo6TErm21VLIyPdpWq4luuN5WIJzD+jcm7bI4D1fyMouLczPWPXUguCpKS/lHun
         yodklqxLsHifwdI/7eMYd97y6F/fXIgeFKXwqJt3ubzbEth14DvCHdP5Bnl78TyIbi3A
         4Im2gM3C1EbpLMxs9SQCe5gJ7RmwxODKX0rO1htV38P5dfhz5Xtrqk4QgeC2BPSOxur+
         mX2n1cpthTDuF2qagnbrZcz0ti5BCvKn+xsQF4QpTt9yixXHvUkl8YWYFzYZZS9V2ww5
         7tdeAA+0exswIgH/yRiTQpQrPBBK12cbNpbmJCK22B2uJyst/94qKRBqH4gzOvwsYaPC
         OFcA==
X-Gm-Message-State: AOAM530v1TjXi7TVqzBKf1UndeFNrYTEQBhzZZRRcnB3hRo0aopkTLez
        0d9ByB/VoqVQHfdoupmplGLGnLCNKdnuadKIlyZcIg==
X-Google-Smtp-Source: ABdhPJwPMsOzCYyNOU4l4H5g9VucjvdO6YBRwp1gXehmk209DTR6o+lmu3TQXFkSVA/URxN74NwOjOcrkqcvy2Apbj0=
X-Received: by 2002:a1c:7308:: with SMTP id d8mr9866967wmb.55.1601273374493;
 Sun, 27 Sep 2020 23:09:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200922155548.v3.1.I67a8b8cd4def8166970ca37109db46d731b62bb6@changeid>
 <BC59363A-B32A-4DAA-BAF5-F7FBA01752E6@holtmann.org> <CAJQfnxHPDktGp=MQJzY57qmMTO7TPfNZvLHLm7DAyZ-4qM-DnQ@mail.gmail.com>
 <6FDED095-BAE4-437D-9A25-37245B8454B1@holtmann.org>
In-Reply-To: <6FDED095-BAE4-437D-9A25-37245B8454B1@holtmann.org>
From:   Archie Pusaka <apusaka@google.com>
Date:   Mon, 28 Sep 2020 14:09:23 +0800
Message-ID: <CAJQfnxFbBRfiDF2xmzzPZ7N3qr41ubH29Fa0FDg9+jh-4OQxhg@mail.gmail.com>
Subject: Re: [PATCH v3] Bluetooth: Check for encryption key size on connect
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marcel,

On Sun, 27 Sep 2020 at 20:09, Marcel Holtmann <marcel@holtmann.org> wrote:
>
> Hi Archie,
>
> >>> When receiving connection, we only check whether the link has been
> >>> encrypted, but not the encryption key size of the link.
> >>>
> >>> This patch adds check for encryption key size, and reject L2CAP
> >>> connection which size is below the specified threshold (default 7)
> >>> with security block.
> >>>
> >>> Here is some btmon trace.
> >>> @ MGMT Event: New Link Key (0x0009) plen 26    {0x0001} [hci0] 5.8477=
22
> >>>       Store hint: No (0x00)
> >>>       BR/EDR Address: 38:00:25:F7:F1:B0 (OUI 38-00-25)
> >>>       Key type: Unauthenticated Combination key from P-192 (0x04)
> >>>       Link key: 7bf2f68c81305d63a6b0ee2c5a7a34bc
> >>>       PIN length: 0
> >>>> HCI Event: Encryption Change (0x08) plen 4        #29 [hci0] 5.87153=
7
> >>>       Status: Success (0x00)
> >>>       Handle: 256
> >>>       Encryption: Enabled with E0 (0x01)
> >>> < HCI Command: Read Encryp... (0x05|0x0008) plen 2  #30 [hci0] 5.8716=
09
> >>>       Handle: 256
> >>>> HCI Event: Command Complete (0x0e) plen 7         #31 [hci0] 5.87252=
4
> >>>     Read Encryption Key Size (0x05|0x0008) ncmd 1
> >>>       Status: Success (0x00)
> >>>       Handle: 256
> >>>       Key size: 3
> >>>
> >>> ////// WITHOUT PATCH //////
> >>>> ACL Data RX: Handle 256 flags 0x02 dlen 12        #42 [hci0] 5.89502=
3
> >>>     L2CAP: Connection Request (0x02) ident 3 len 4
> >>>       PSM: 4097 (0x1001)
> >>>       Source CID: 64
> >>> < ACL Data TX: Handle 256 flags 0x00 dlen 16        #43 [hci0] 5.8952=
13
> >>>     L2CAP: Connection Response (0x03) ident 3 len 8
> >>>       Destination CID: 64
> >>>       Source CID: 64
> >>>       Result: Connection successful (0x0000)
> >>>       Status: No further information available (0x0000)
> >>>
> >>> ////// WITH PATCH //////
> >>>> ACL Data RX: Handle 256 flags 0x02 dlen 12        #42 [hci0] 4.88702=
4
> >>>     L2CAP: Connection Request (0x02) ident 3 len 4
> >>>       PSM: 4097 (0x1001)
> >>>       Source CID: 64
> >>> < ACL Data TX: Handle 256 flags 0x00 dlen 16        #43 [hci0] 4.8871=
27
> >>>     L2CAP: Connection Response (0x03) ident 3 len 8
> >>>       Destination CID: 0
> >>>       Source CID: 64
> >>>       Result: Connection refused - security block (0x0003)
> >>>       Status: No further information available (0x0000)
> >>>
> >>> Signed-off-by: Archie Pusaka <apusaka@chromium.org>
> >>>
> >>> ---
> >>>
> >>> Changes in v3:
> >>> * Move the check to hci_conn_check_link_mode()
> >>>
> >>> Changes in v2:
> >>> * Add btmon trace to the commit message
> >>>
> >>> net/bluetooth/hci_conn.c | 4 ++++
> >>> 1 file changed, 4 insertions(+)
> >>>
> >>> diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
> >>> index 9832f8445d43..89085fac797c 100644
> >>> --- a/net/bluetooth/hci_conn.c
> >>> +++ b/net/bluetooth/hci_conn.c
> >>> @@ -1348,6 +1348,10 @@ int hci_conn_check_link_mode(struct hci_conn *=
conn)
> >>>          !test_bit(HCI_CONN_ENCRYPT, &conn->flags))
> >>>              return 0;
> >>>
> >>> +     if (test_bit(HCI_CONN_ENCRYPT, &conn->flags) &&
> >>> +         conn->enc_key_size < conn->hdev->min_enc_key_size)
> >>> +             return 0;
> >>> +
> >>>      return 1;
> >>> }
> >>
> >> I am a bit concerned since we had that check and I on purpose moved it=
. See commit 693cd8ce3f88 for the change where I removed and commit d5bb334=
a8e17 where I initially added it.
> >>
> >> Naively adding the check in that location caused a major regression wi=
th Bluetooth 2.0 devices. This makes me a bit reluctant to re-add it here s=
ince I restructured the whole change to check the key size a different loca=
tion.
> >
> > I have tried this patch (both v2 and v3) to connect with a Bluetooth
> > 2.0 device, it doesn't have any connection problem.
> > I suppose because in the original patch (d5bb334a8e17), there is no
> > check for the HCI_CONN_ENCRYPT flag.
>
> while that might be the case, I am still super careful. Especially also i=
n conjunction with the email / patch from Alex trying to add just another e=
ncryption key size check. If we really need them or even both, we have to a=
udit the whole code since I must have clearly missed something when adding =
the KNOB fix.
>
> >> Now I have to ask, are you running an upstream kernel with both commit=
s above that address KNOB vulnerability?
> >
> > Actually no, I haven't heard of KNOB vulnerability before.
> > This patch is written for qualification purposes, specifically to pass
> > GAP/SEC/SEM/BI-05-C to BI-08-C.
> > However, it sounds like it could also prevent some KNOB vulnerability
> > as a bonus.
>
> That part worries me since there should be no gaps that allows an encrypt=
ion key size downgrade if our side supports Read Encryption Key Size.
>
> We really have to ensure that any L2CAP communication is stalled until we=
 have all information from HCI connection setup that we need. So maybe the =
change Alex did would work as well, or as I mentioned put any L2CAP connect=
ion request as pending so that the validation happens in one place.

I think Alex and I are solving the same problem, either one of the
patches should be enough.

Here is my test method using BlueZ as both the IUT and the lower test.
(1) Copy the bluez/test/test-profile python script to IUT and lower test.
(2) Assign a fake service server to IUT
python test-profile -u 00001fff-0000-1000-2000-123456789abc -s -P 4097
(3) Assign a fake service client to lower test
python test-profile -u 00001fff-0000-1000-2000-123456789abc -c
(4) Make the lower test accept weak encryption key
echo 1 > /sys/kernel/debug/bluetooth/hci0/min_encrypt_key_size
(5) Enable ssp and disable sc on lower test
btmgmt ssp on
btmgmt sc off
(6) Set lower test encryption key size to 1
(7) initiate connection from lower test
dbus-send --system --print-reply --dest=3Dorg.bluez
/org/bluez/hci0/dev_<IUT> org.bluez.Device1.ConnectProfile
string:00001fff-0000-1000-2000-123456789abc

After MITM authentication, IUT will incorrectly accept the connection,
even though the encryption key used is less than the one specified in
IUT's min_encrypt_key_size.

>
> Regards
>
> Marcel
>

Thanks,
Archie
