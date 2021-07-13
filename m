Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA3D3C6BAA
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 09:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbhGMHtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 03:49:01 -0400
Received: from mx-lax3-1.ucr.edu ([169.235.156.35]:34785 "EHLO
        mx-lax3-1.ucr.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234121AbhGMHtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 03:49:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1626162372; x=1657698372;
  h=mime-version:references:in-reply-to:from:date:message-id:
   subject:to:cc;
  bh=/PDBt9wlRWM1iCLp+k/CLplY3xQTV5OM8VyXbBUUaog=;
  b=AgJvR9YPOYo55oU70TRbahZTMKg6od1iLRg1jd/q48MB0yRH647MZzGo
   J0kj0Itca9NCmteud7SkvM1D4IT24kdwANMioLhFdIcLFwMZp0Qk81k3U
   dApJ92iDZQyQ0dHxDteJs4GxJGap15IX4vMRMHGIa9O7+I6syVgXkFhHe
   D9UZ20fk33PGPNj8w3Hs1L3juNk5b7GpsuMdORnCky/hL8wqCWxii+Zna
   7W7VUk/wPIA3rbF5sTyzNMEdF9Zo02seGtb/0gWCaZkbHG+1ct1fhDu/C
   3Fna1tWb3W4YyVTzLvSq9/6kwyHZk/ptnN8+lA1KF14Gqcwn3Yf33u9TP
   A==;
IronPort-SDR: dHlj/TllYxveIShof/sAcdPj3C637vmUtmpiRpWQluC0pdxC0enlkgcxP3y/3rMsw+WbtNLUhe
 Cf8g/sYRTNobvsrlqvtd3IeKKmkH22uEg2TKbh6DNe7H8mmjspwVteuTNP1YGCZx9WRi93zoNR
 Mfy9FcqAT6Nnz39KpwD6JJvV2/iGLS6y2hOEZScdo+X6emRGyaAczBoGuLALeZdTirxmphjdkY
 fS8NmJ3zpO1s29Xg6Uje3A1FTr3fd+x38STIwXAgpiAe7GvY2Gdmqi7T17w08iR5jOiILQBwfA
 /sI=
X-IPAS-Result: =?us-ascii?q?A2HjAgDOQ+1gdEihVdFaHgEBCxIMQIFOC4MiVmwCGIQuk?=
 =?us-ascii?q?VsDlhuCa4JUgXwCCQEBAQ83CgQBAQMBA4ESgndEAm2CDAIlNAkOAgQBAQEBA?=
 =?us-ascii?q?wIDAQEBAQUBAQYBAQEBAQEFBAEBAhABb4UvOQ2COCkBUhIDDVYBAQEBAQEBA?=
 =?us-ascii?q?QEBAQEBAQEBIAIBAQEmAggFTQVnAQEBAxIRBFIOAgsLDQICJgICGwcSAQUBH?=
 =?us-ascii?q?AYTCBqCUIMHD5s6gQQ9izJ/M4EBiCEBCQ2BXQYFDX4qhwmGYieCKYFLgQWBa?=
 =?us-ascii?q?j6CYgSEdYJkBIMZTFUYe1JtQFMBAQGfCpp2gg8BBgKDChyKMpQCK4Nji1yFe?=
 =?us-ascii?q?0KQWC2UR41AkxcLhUkQI4E4ghUzGiV/BmeBS1AZDod/hiwWg04zikskLwIBD?=
 =?us-ascii?q?CkCBgoBAQMJh2cBAQ?=
IronPort-PHdr: A9a23:SiugfxYabDvWuUTFlKq/HOv/LTGI0IqcDmcuAnoPtbtCf+yZ8oj4O
 wSHvLMx1gePBNmQtawMy7KP9fy5CCpYudfJmUtBWaQEbwUCh8QSkl5oK+++Imq/EsTXaTcnF
 t9JTl5v8iLzG0FUHMHjew+a+SXqvnYdFRrlKAV6OPn+FJLMgMSrzeCy/IDYbxlViDanbr5+M
 gm6oR/MusQZjodvK6c8wQbNrndUZuha32xlKU+Xkhrm+su84Jtv+DlMtvw88MJNTb/0dLkiQ
 7xCCzQmPWE15Mn1uhTGUACC+HgSXHgInxRRGwTK4w30UZn3sivhq+pywzKaMtHsTbA1Qjut8
 aFmQwL1hSgdNj459GbXitFsjK9evRmsqQBzz5LSbYqIL/d1YL/Tcs0GSmpARsZRVjJOAoWgb
 4sUEuENOf9Uo5Thq1cSqBezAxSnCuHyxT9SnnL50qM63OYhHw/I3wIuAswAv2jPodXpKKsfS
 /y5wLXUwTjBaf5dxDfz6JLPchAkufyDXLNwftDWyUYzFwPKkFOQopHmMDOSy+QGrm+W7uVhV
 OKolm4rtxx9rzq0y8cxlobJnJgZxU7Z+iVk2Ys4I8CzR0Fnb9C+CpRQqz2aOJVsQsMkW2xlt
 ig0x6AYtZKmfyUG1IoqyhzeZvKIc4aF/xLuWeaPLDp6inxofLyyigu9/0WiyuPxV8e63lZJo
 yZZkNTBqH4A2hrO4caJTft9+12u2TeJ1w3L8e5EJkc0lbbfK54gxL48jIYcsUPGHiPugEX5k
 qmWdko5+ui08eTnZbPmpp6TNoNulw7xLKIjkdG8D+QgKgUCQXSX9OCm2LDg/UD1WqhGg/wrn
 qXDsp3WO8IWrbOjDQBPyIYs8RO/Ai+j0NQfgHYIMkpIeAmCj4j1I1HOJ+34Deunj1Ssjjhrw
 /fGM6XkAprXL3jDlK7tfbF660JB0QYzw9JS64xOBrEOJ/LzXUDxtNjGARMjLwO0xOPnBM181
 oMYR22PHreUPL3OvVKM/O4iIOmBaJUItDv8NvQp/fzjgWEhlV8YZ6ap3J8XaH6iHvRhJkWUe
 XXtg9YGEWcXogYyUe7nhUafUTFPfXa+Rbwz6SwmCI6+F4fMWpitgKCd3Ce8BpBWYH5JCkyRH
 nj2aYWJQOkMaC2MLc97iDAEVqauS5Un1R6wsA/20b1nLvDb+n5QiZW28dFv7KXwkRwz8zExJ
 dmR32zFG2R3mksQSjk5wbxlpkp82hGP3P4rreZfEIlj5vpOWQc3M9buyPEyX8DgXR+ZJ4ihV
 V28BNiqHGdiHZoK39YSbhMlSJ2ZhRfZ0n/vWudN/4E=
IronPort-HdrOrdr: A9a23:KR7So6yAbJeyArRdBqgtKrPwF71zdoMgy1knxilNoNJuA7Wlfq
 GV7YwmPHDP+VMssR0b6LK90ey7MBDhHP1OgLX5X43SODUO0VHAROpfBMnZowEIcBeOkdK1u5
 0QFZSWy+ecMbG5t6zHCcWDfOrICePqnpyVuQ==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.84,236,1620716400"; 
   d="scan'208";a="53814363"
Received: from mail-oo1-f72.google.com ([209.85.161.72])
  by smtp-lax3-1.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jul 2021 00:46:11 -0700
Received: by mail-oo1-f72.google.com with SMTP id k13-20020a4ad10d0000b029025ec20a413eso2066314oor.11
        for <netdev@vger.kernel.org>; Tue, 13 Jul 2021 00:46:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E0c/itnJRqvseiRzZWaYFdOYbaZVWfzwqyJIgaHRkI4=;
        b=sO1sUxX/EIFtS38HCtE6GBlMPGNuFN9K9dJL1iYohpEUr0A0gKPZBG+1kc1KbZM4zn
         7Tz7ir+iduZ9mO09aJGWWKZ94yQW8WURUmhKjhYu2ATVQ2HNLML3P0EiNi0wzikpEKhk
         LaL/7M3OeCjcVcfPuymW/UCEjjuKOiFJXUrWMgvPqEQkcSjNsrDoNEAh5qwnS5GBdPAb
         7zCC/MG8MFftAyndjgaseIoIg+Cbw/D+XRVd41QRCLZdPb0Fy8cC8LsVq6kXFC2VizML
         Ax/KkD7XPgO9MHVawUadowPwEt+fR3N6Ps7A+z7xizgpLLaguHoE1rmX4AqKgulmgNkM
         yjGg==
X-Gm-Message-State: AOAM531Q5jbkaixK7Lt2iPRakRLh3LnH4ObAQSuOICAK658re1htsPka
        R6vCrKKCPXvJTBkWGhPhKLlIAYanHJ8e82P5lymZOzJSeqD66GIoh7uQRaV5n10VLLJs/v9aL4h
        +4PmaCFC2KSNUmrG/oKH+wCYuAGwh8rzo7A==
X-Received: by 2002:a05:6830:1e42:: with SMTP id e2mr2537582otj.135.1626162369808;
        Tue, 13 Jul 2021 00:46:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwBf6asctnycGHrf0aHsUd7mMNxKyN11KyP8TucFVKHbFU6gvW9YJZO6cqXJ6+ucEspUXAJ06v7fWy8ISSDRwE=
X-Received: by 2002:a05:6830:1e42:: with SMTP id e2mr2537573otj.135.1626162369633;
 Tue, 13 Jul 2021 00:46:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAE1SXrtrg4CrWg_rZLUHqWWFHkGnK5Ez0PExJq8-A9d5NjE_-w@mail.gmail.com>
 <YO0Z7s8p7CoetxdW@kroah.com> <CAE1SXrv2Et9icDf2NesjWmrwbjXL8067Y=D3RnwqpEeZT4OgTg@mail.gmail.com>
 <e1f71c33-a5dd-82b1-2dce-be4f052d6aa6@pengutronix.de>
In-Reply-To: <e1f71c33-a5dd-82b1-2dce-be4f052d6aa6@pengutronix.de>
From:   Xiaochen Zou <xzou017@ucr.edu>
Date:   Tue, 13 Jul 2021 00:46:07 -0700
Message-ID: <CAE1SXrv3Ouwt4Y9NEWGi0WO701w1YP1ruMSxraZr4PZTGsUZgg@mail.gmail.com>
Subject: Re: Use-after-free access in j1939_session_deactivate
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Greg KH <greg@kroah.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

j1939_session_destroy() will free both session and session->priv. It
leads to multiple use-after-free read and write in
j1939_session_deactivate() when session was freed in
j1939_session_deactivate_locked(). The free chain is
j1939_session_deactivate_locked()->j1939_session_put()->__j1939_session_release()->j1939_session_destroy().
To fix this bug, I moved j1939_session_put() behind
j1939_session_deactivate_locked() and guarded it with a check of
active since the session would be freed only if active is true.

Signed-off-by: Xiaochen Zou <xzou017@ucr.edu>

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index e5f1a56994c6..b6448f29a4bd 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1018,7 +1018,6 @@ static bool
j1939_session_deactivate_locked(struct j1939_session *session)

        list_del_init(&session->active_session_list_entry);
        session->state = J1939_SESSION_DONE;
-       j1939_session_put(session);
    }

    return active;
@@ -1031,6 +1030,9 @@ static bool j1939_session_deactivate(struct
j1939_session *session)
    j1939_session_list_lock(session->priv);
    active = j1939_session_deactivate_locked(session);
    j1939_session_list_unlock(session->priv);
+   if (active) {
+       j1939_session_put(session);
+   }

    return active;
 }
@@ -2021,6 +2023,7 @@ void j1939_simple_recv(struct j1939_priv *priv,
struct sk_buff *skb)
 int j1939_cancel_active_session(struct j1939_priv *priv, struct sock *sk)
 {
    struct j1939_session *session, *saved;
+   bool active;

    netdev_dbg(priv->ndev, "%s, sk: %p\n", __func__, sk);
    j1939_session_list_lock(priv);
@@ -2030,7 +2033,10 @@ int j1939_cancel_active_session(struct
j1939_priv *priv, struct sock *sk)
        if (!sk || sk == session->sk) {
            j1939_session_timers_cancel(session);
            session->err = ESHUTDOWN;
-           j1939_session_deactivate_locked(session);
+           active = j1939_session_deactivate_locked(session);
+           if (active) {
+               j1939_session_put(session);
+           }
        }
    }
    j1939_session_list_unlock(priv);

On Tue, Jul 13, 2021 at 12:35 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
>
> On 7/13/21 9:30 AM, Xiaochen Zou wrote:
> > j1939_session_destroy() will free both session and session->priv. It
> > leads to multiple use-after-free read and write in
> > j1939_session_deactivate() when session was freed in
> > j1939_session_deactivate_locked(). The free chain is
> > j1939_session_deactivate_locked()->
> > j1939_session_put()->__j1939_session_release()->j1939_session_destroy().
> > To fix this bug, I moved j1939_session_put() behind
> > j1939_session_deactivate_locked() and guarded it with a check of
> > active since the session would be freed only if active is true.
>
> Please include your Signed-off-by.
> See
> https://elixir.bootlin.com/linux/v5.12/source/Documentation/process/submitting-patches.rst#L356
>
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
>


-- 
Xiaochen Zou
PhD Student
Department of Computer Science & Engineering
University of California, Riverside
