Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBE05A2C6F
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 18:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244060AbiHZQjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 12:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238115AbiHZQjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 12:39:04 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35734DF0A5
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 09:39:03 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id q8so1459632qvr.9
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 09:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=IwKGAXaznXCIAxrDP5DUD2f3lCLU/HKsW3KIPjcgZ/U=;
        b=bMNeRItmNu80iaULKM4SL6d9w61PmjPBWeeQpmHMlNh8+0AAfG+122zI1A39o44XjK
         U+IgprcQsvWqa1ITX4DCrEPOBbZ7v9cODX47FILt3pSC1KfOyzPmo03RO5OxxbN+cfkQ
         v1TP7b3PlnG9hqKws+Y18Enhr4IzVar9vPRO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=IwKGAXaznXCIAxrDP5DUD2f3lCLU/HKsW3KIPjcgZ/U=;
        b=jo1QeznsCs1OGLzszVX5u2lZHdnr7qNHh8LfjgWCYwpX0eAdqZisP6qhlQoL3V8Bwk
         +01YVIUcRwAJZUgPIbyymE/rE17WctK9vmWTnEEuYuLuv95EpXCQum5Q0EepLRK8MNwj
         XDsh/da2sHFPs0uz4hjM2+25GrMSJa9TxFgWB0Xxj0N08HAln+m9yQpYsPUaw/wJj0Zr
         ZUjuEYFzjNs4tru1BOhbsMWFplmVIv8LSveevbfLPag9WAtnbbiZ/aIS19R3P/WR4TO/
         wJgqBOEYUG1xazoom7uKxVVU9eaCSl2hH5n7P24rwIi8Lq10/XCasn8NA5MKFacTvA0X
         83Pg==
X-Gm-Message-State: ACgBeo35XfuT9nIp2EntAUGNzEQO9vwcwOBGe5J9T2Tl3Vr2TGGp4qBL
        PYOKBsC1+rDi3JsJULMSYJ1wiXYd+aHKtiLpIwfCKw==
X-Google-Smtp-Source: AA6agR4lXc6X8L6bq586YXslvNj/DJDt44cmY8imrg+xFKDrP52quWsQQncFPAvWyO2cd6CEDuty6k8RnDxyBe8b1zA=
X-Received: by 2002:ad4:5f49:0:b0:496:dcbf:d61e with SMTP id
 p9-20020ad45f49000000b00496dcbfd61emr469328qvg.4.1661531942208; Fri, 26 Aug
 2022 09:39:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220826002530.1153296-1-kai.heng.feng@canonical.com> <CANn89i+hm1MmbQQRtPg7CbCihfYfoNjDt6ZJKRyNpJHAENp8oQ@mail.gmail.com>
In-Reply-To: <CANn89i+hm1MmbQQRtPg7CbCihfYfoNjDt6ZJKRyNpJHAENp8oQ@mail.gmail.com>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Fri, 26 Aug 2022 09:38:51 -0700
Message-ID: <CACKFLi==iTvmSKwAcaFFpwCDNd+EQ9N1vS7+o4DRiTHdScMs4w@mail.gmail.com>
Subject: Re: [PATCH v2] tg3: Disable tg3 device on system reboot to avoid
 triggering AER
To:     Eric Dumazet <edumazet@google.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        Josef Bacik <josef@toxicpanda.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000385ab605e7278ddd"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--000000000000385ab605e7278ddd
Content-Type: text/plain; charset="UTF-8"

On Fri, Aug 26, 2022 at 9:19 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Aug 25, 2022 at 5:25 PM Kai-Heng Feng
> <kai.heng.feng@canonical.com> wrote:
> >
> > Commit d60cd06331a3 ("PM: ACPI: reboot: Use S5 for reboot") caused a
> > reboot hang on one Dell servers so the commit was reverted.
> >
> > Someone managed to collect the AER log and it's caused by MSI:
> > [ 148.762067] ACPI: Preparing to enter system sleep state S5
> > [ 148.794638] {1}[Hardware Error]: Hardware error from APEI Generic Hardware Error Source: 5
> > [ 148.803731] {1}[Hardware Error]: event severity: recoverable
> > [ 148.810191] {1}[Hardware Error]: Error 0, type: fatal
> > [ 148.816088] {1}[Hardware Error]: section_type: PCIe error
> > [ 148.822391] {1}[Hardware Error]: port_type: 0, PCIe end point
> > [ 148.829026] {1}[Hardware Error]: version: 3.0
> > [ 148.834266] {1}[Hardware Error]: command: 0x0006, status: 0x0010
> > [ 148.841140] {1}[Hardware Error]: device_id: 0000:04:00.0
> > [ 148.847309] {1}[Hardware Error]: slot: 0
> > [ 148.852077] {1}[Hardware Error]: secondary_bus: 0x00
> > [ 148.857876] {1}[Hardware Error]: vendor_id: 0x14e4, device_id: 0x165f
> > [ 148.865145] {1}[Hardware Error]: class_code: 020000
> > [ 148.870845] {1}[Hardware Error]: aer_uncor_status: 0x00100000, aer_uncor_mask: 0x00010000
> > [ 148.879842] {1}[Hardware Error]: aer_uncor_severity: 0x000ef030
> > [ 148.886575] {1}[Hardware Error]: TLP Header: 40000001 0000030f 90028090 00000000
> > [ 148.894823] tg3 0000:04:00.0: AER: aer_status: 0x00100000, aer_mask: 0x00010000
> > [ 148.902795] tg3 0000:04:00.0: AER: [20] UnsupReq (First)
> > [ 148.910234] tg3 0000:04:00.0: AER: aer_layer=Transaction Layer, aer_agent=Requester ID
> > [ 148.918806] tg3 0000:04:00.0: AER: aer_uncor_severity: 0x000ef030
> > [ 148.925558] tg3 0000:04:00.0: AER: TLP Header: 40000001 0000030f 90028090 00000000
> >
> > The MSI is probably raised by incoming packets, so power down the device
> > and disable bus mastering to stop the traffic, as user confirmed this
> > approach works.
> >
> > In addition to that, be extra safe and cancel reset task if it's running.
> >
> > Cc: Josef Bacik <josef@toxicpanda.com>
> > Link: https://lore.kernel.org/all/b8db79e6857c41dab4ef08bdf826ea7c47e3bafc.1615947283.git.josef@toxicpanda.com/
> > BugLink: https://bugs.launchpad.net/bugs/1917471
> > Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> > ---
> > v2:
> >  - Move tg3_reset_task_cancel() outside of rtnl_lock() to prevent
> >    deadlock.
> >
>
> It seems tg3_reset_task_cancel() is already called while rtnl is held/owned.
> Should we worry about that ?

In this shutdown code path, if we cancel it before rtnl_lock(), the
TG3_FLAG_RESET_TASK_PENDING flag will be cleared and we will not try
to cancel it again later when rtnl_lock() is held.

But I agree that calling tg3_reset_task_cancel() under rtnl_lock can
potentially deadlock if the reset_task is scheduled and we wait for it
to finish.  That logic should be fixed separately.

>
> >  drivers/net/ethernet/broadcom/tg3.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
> > index db1e9d810b416..89889d8150da1 100644
> > --- a/drivers/net/ethernet/broadcom/tg3.c
> > +++ b/drivers/net/ethernet/broadcom/tg3.c
> > @@ -18076,16 +18076,20 @@ static void tg3_shutdown(struct pci_dev *pdev)
> >         struct net_device *dev = pci_get_drvdata(pdev);
> >         struct tg3 *tp = netdev_priv(dev);
> >
> > +       tg3_reset_task_cancel(tp);
> > +
> >         rtnl_lock();
> > +
> >         netif_device_detach(dev);
> >
> >         if (netif_running(dev))
> >                 dev_close(dev);
> >
> > -       if (system_state == SYSTEM_POWER_OFF)
> > -               tg3_power_down(tp);
> > +       tg3_power_down(tp);
> >
> >         rtnl_unlock();
> > +
> > +       pci_disable_device(pdev);
> >  }
> >
> >  /**
> > --
> > 2.36.1
> >

--000000000000385ab605e7278ddd
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
xV4Em+0wQoEIR2kPG6yiZNtUK0tNCaZejYU/Mf/bzdKSwud3pLgHV8ls83y2OU/ha9xgJMLpRswv
xucFCxMsPmk0yoVmpbr92kIpLm+TomNZsL++LcDRa2ECAwEAAaOCAdowggHWMA4GA1UdDwEB/wQE
AwIFoDCBowYIKwYBBQUHAQEEgZYwgZMwTgYIKwYBBQUHMAKGQmh0dHA6Ly9zZWN1cmUuZ2xvYmFs
c2lnbi5jb20vY2FjZXJ0L2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNydDBBBggrBgEFBQcw
AYY1aHR0cDovL29jc3AuZ2xvYmFsc2lnbi5jb20vZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAw
TQYDVR0gBEYwRDBCBgorBgEEAaAyASgKMDQwMgYIKwYBBQUHAgEWJmh0dHBzOi8vd3d3Lmdsb2Jh
bHNpZ24uY29tL3JlcG9zaXRvcnkvMAkGA1UdEwQCMAAwSQYDVR0fBEIwQDA+oDygOoY4aHR0cDov
L2NybC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWduMmNhMjAyMC5jcmwwJAYDVR0R
BB0wG4EZbWljaGFlbC5jaGFuQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggrBgEFBQcDBDAfBgNV
HSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUz2bMvqtXpXM0u3vAvRkalz60
CjswDQYJKoZIhvcNAQELBQADggEBAGUgeqqI/q2pkETeLr6oS7nnm1bkeNmtnJ2bnybNO/RdrbPj
DHVSiDCCrWr6xrc+q6OiZDKm0Ieq6BN+Wfr8h5mCkZMUdJikI85WcQTRk6EEF2lzIiaULmFD7U15
FSWQptLx+kiu63idTII4r3k/7+dJ5AhLRr4WCoXEme2GZkfSbYC3fEL46tb1w7w+25OEFCv1MtDZ
1CHkODrS2JGwDQxXKmyF64MhJiOutWHmqoGmLJVz1jnDvClsYtgT4zcNtoqKtjpWDYAefncWDPIQ
DauX1eWVM+KepL7zoSNzVbTipc65WuZFLR8ngOwkpknqvS9n/nKd885m23oIocC+GA4xggJtMIIC
aQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQD
EyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwQeU+Y6hbenPzRMJsw
DQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILpiXCwcI0dcDzJPJcyIoEC0Q0SamTv9
R9spPCi+fEdoMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTIyMDgy
NjE2MzkwMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQC
ATANBgkqhkiG9w0BAQEFAASCAQAcpm7U3J/K/qAkH7ij4+nwvSZjvAzFPnTbbW2R+IV1hFEtsHWB
F/zw7shHaqZKSqDCeBzrKaZXAnn13Wz/kBEoVelfYIfUpYXGVcTE0HA2SmRPRrlyjltwmk8K51Zx
0bJLKfKj4NtnshR+KDaoMYD01ighue9IARSATaLcm4/kTOu5qmNIicuNsHDU+UVmBOMpwatswa8e
8UFBXLREfV/InHN12W/keClg0mla+VDX3/euYlaxZjJszN/oiF+eOCwl4gSXTLWAhjXoVwa+thjF
Ci0JTI23R/vWKkuUHCOQZYlCco2Lw+EyX14irlEspvlPTisG58MHXBF7RuOLg5nk
--000000000000385ab605e7278ddd--
