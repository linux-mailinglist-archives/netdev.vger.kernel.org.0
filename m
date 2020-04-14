Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC07E1A7A71
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 14:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439950AbgDNMOe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 08:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729799AbgDNMOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 08:14:30 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F21DC061A0C;
        Tue, 14 Apr 2020 05:14:30 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e26so12728551wmk.5;
        Tue, 14 Apr 2020 05:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=Mcttf0CjZrqLA+n5R7K5KnAzyihpiLvE7jQbeZbjFog=;
        b=P6whjt/doR8M5Wl7pux7ZEjDvSxJLoE6rSrw/9S/OdD54g8MU/H7rxbsofGjeZqzLb
         rfMGHgIFcYu1Nir+4g3NO310lIehamf5GeavD7mn+FJE0/G/2lsUYsiVhtO87Evg5Jg8
         RiBT0IXG7zycmzsgsPtc4d0XAt1rMksAaWb5KQioeX0yarl8O1fmYjxVjpZg1I9gIVrp
         F7k4OndvwyqNAwLG76iUY+feWaNXSZoeaedvB/JJtCv7GJg8th4+K8X5COzX5NFZQhwq
         qh5nmP/UHdCrRF0xQjF2lR2e1QAi6HgfXhcpOL2SFpL3oacBs42b7Kefw79zk01LQdV4
         PC+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=Mcttf0CjZrqLA+n5R7K5KnAzyihpiLvE7jQbeZbjFog=;
        b=JweXjpnU6YsMbyZMIfGJCTLC7+jnmN5L8/U+CMUuL94JwGLd0L6Ddsi6GFFz7Lu4Z7
         6jMGdzG/QBCL3fhBW7Y0euDfASvaq+Sne0i0y8rQ/Nqmo7Oo603lSmUZkIf5CvpW3wV/
         hf61nuPHqMZG27F5mIZxFiC0cl21fauXZKxeCBkCM0kmDFOJoPMfSSc6m7Z4D11NnCd1
         GABbn3pQQfGnBSgVyz6WSfzsqEWcbdiLRDomfIfQ5co+luPswesKjMcHorH+MfEdCt5m
         NX9eJo71oeGzRxyEITs5QM69Sba2hxRHuQBakCRawgYREqZ2eqSg3MlUZ8bZlTkYTZ6r
         PxHw==
X-Gm-Message-State: AGi0PubZVu4Q/9+TC4pTW4Ea9pH5FEakTAklViLYwg0m5UZf6gbIhEu0
        n6UmVL4dn5jzy2NBNdoe86eY3DLOxiYw5eXN8/g=
X-Google-Smtp-Source: APiQypIigEskMJRUW5ejRmzmnZjegOR/T+QsYZxccdPkFD4v0S/u8Fz0EmfNXBeZfuY71Xg+Z4tTyqVmuGRKkhNNIh8=
X-Received: by 2002:a7b:cb86:: with SMTP id m6mr22108261wmi.64.1586866468976;
 Tue, 14 Apr 2020 05:14:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200402050219.4842-1-chris@rorvick.com> <87mu7qfhiy.fsf@codeaurora.org>
 <e43fb61905bcc31f93d6e72e5c470ad5585b6dfd.camel@coelho.fi> <87zhbqz44s.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87zhbqz44s.fsf@kamboji.qca.qualcomm.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 14 Apr 2020 14:14:17 +0200
Message-ID: <CA+icZUWBb+M884XeSaO0vw+txg9yac3out+wXNtzjLnFmcMOsQ@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: actually check allocated conf_tlv pointer
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Luca Coelho <luca@coelho.fi>, Chris Rorvick <chris@rorvick.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: multipart/mixed; boundary="00000000000030972905a33f248b"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000030972905a33f248b
Content-Type: text/plain; charset="UTF-8"

On Sun, Apr 5, 2020 at 11:14 AM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Luca Coelho <luca@coelho.fi> writes:
>
> > On Sun, 2020-04-05 at 11:44 +0300, Kalle Valo wrote:
> >> Chris Rorvick <chris@rorvick.com> writes:
> >>
> >> > Commit 71bc0334a637 ("iwlwifi: check allocated pointer when allocating
> >> > conf_tlvs") attempted to fix a typoe introduced by commit 17b809c9b22e
> >> > ("iwlwifi: dbg: move debug data to a struct") but does not implement the
> >> > check correctly.
> >> >
> >> > Tweeted-by: @grsecurity
> >> > Signed-off-by: Chris Rorvick <chris@rorvick.com>
> >>
> >> I'll add:
> >>
> >> Fixes: 71bc0334a637 ("iwlwifi: check allocated pointer when allocating conf_tlvs")
> >>
> >> > ---
> >> > In this wasn't picked up?
> >>
> >> Luca, can I take this directly?
> >
> > Yes, please take it directly.
>
> Ok, assigned it to me in patchwork.
>
> > This can happen in OOM situations and, when it does, we will
> > potentially try to dereference a NULL pointer.
>
> I'll add this to the commit log.
>

Hi,

Friendly ping.

Any progress on this?

This patch seems not have landed in Linux v5.7-rc1.

$ head -5 Makefile
# SPDX-License-Identifier: GPL-2.0
VERSION = 5
PATCHLEVEL = 7
SUBLEVEL = 0
EXTRAVERSION = -rc1

$ LC_ALL=C git apply --check --verbose
../patches/iwlwifi-fixes-5.6/iwlwifi-actually-check-allocated-conf_tlv-pointer-v2-dileks.patch
Checking patch drivers/net/wireless/intel/iwlwifi/iwl-drv.c...

I have attached my v2 which I have tested on top of Linux v5.6.3.

Feel free to add my...

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

Regards,
- Sedat -

--00000000000030972905a33f248b
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="iwlwifi-actually-check-allocated-conf_tlv-pointer-v2-dileks.patch"
Content-Disposition: attachment; 
	filename="iwlwifi-actually-check-allocated-conf_tlv-pointer-v2-dileks.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k8zv90az0>
X-Attachment-Id: f_k8zv90az0

RnJvbSBwYXRjaHdvcmsgVGh1IEFwciAgMiAwNTowMjoxOSAyMDIwCkNvbnRlbnQtVHlwZTogdGV4
dC9wbGFpbjsgY2hhcnNldD0idXRmLTgiCk1JTUUtVmVyc2lvbjogMS4wCkNvbnRlbnQtVHJhbnNm
ZXItRW5jb2Rpbmc6IDdiaXQKWC1QYXRjaHdvcmstU3VibWl0dGVyOiBDaHJpcyBSb3J2aWNrIDxj
aHJpc0Byb3J2aWNrLmNvbT4KWC1QYXRjaHdvcmstSWQ6IDExNDcwMTI1ClgtUGF0Y2h3b3JrLURl
bGVnYXRlOiBrdmFsb0BhZHVyb20uY29tClJldHVybi1QYXRoOiA8U1JTMD1waW9tPTVTPXZnZXIu
a2VybmVsLm9yZz1saW51eC13aXJlbGVzcy1vd25lckBrZXJuZWwub3JnPgpSZWNlaXZlZDogZnJv
bSBtYWlsLmtlcm5lbC5vcmcgKHBkeC1rb3JnLW1haWwtMS53ZWIuY29kZWF1cm9yYS5vcmcKIFsx
NzIuMzAuMjAwLjEyM10pCglieSBwZHgta29yZy1wYXRjaHdvcmstMi53ZWIuY29kZWF1cm9yYS5v
cmcgKFBvc3RmaXgpIHdpdGggRVNNVFAgaWQgNDkxODExNUFCCglmb3IgPHBhdGNod29yay1saW51
eC13aXJlbGVzc0BwYXRjaHdvcmsua2VybmVsLm9yZz47CiBUaHUsICAyIEFwciAyMDIwIDA1OjQw
OjIyICswMDAwIChVVEMpClJlY2VpdmVkOiBmcm9tIHZnZXIua2VybmVsLm9yZyAodmdlci5rZXJu
ZWwub3JnIFsyMDkuMTMyLjE4MC42N10pCglieSBtYWlsLmtlcm5lbC5vcmcgKFBvc3RmaXgpIHdp
dGggRVNNVFAgaWQgMjZDRjcyMDc4NAoJZm9yIDxwYXRjaHdvcmstbGludXgtd2lyZWxlc3NAcGF0
Y2h3b3JrLmtlcm5lbC5vcmc+OwogVGh1LCAgMiBBcHIgMjAyMCAwNTo0MDoyMiArMDAwMCAoVVRD
KQpBdXRoZW50aWNhdGlvbi1SZXN1bHRzOiBtYWlsLmtlcm5lbC5vcmc7Cglka2ltPWZhaWwgcmVh
c29uPSJzaWduYXR1cmUgdmVyaWZpY2F0aW9uIGZhaWxlZCIgKDIwNDgtYml0IGtleSkKIGhlYWRl
ci5kPWdtYWlsLmNvbSBoZWFkZXIuaT1AZ21haWwuY29tIGhlYWRlci5iPSJvR2dSaUN5RyIKUmVj
ZWl2ZWQ6IChtYWpvcmRvbW9Admdlci5rZXJuZWwub3JnKSBieSB2Z2VyLmtlcm5lbC5vcmcgdmlh
IGxpc3RleHBhbmQKICAgICAgICBpZCBTMTcyNzc0NkFiZ0RCRmtSIChPUkNQVAogICAgICAgIDxy
ZmM4MjI7cGF0Y2h3b3JrLWxpbnV4LXdpcmVsZXNzQHBhdGNod29yay5rZXJuZWwub3JnPik7CiAg
ICAgICAgVGh1LCAyIEFwciAyMDIwIDAxOjQwOjE3IC0wNDAwClJlY2VpdmVkOiBmcm9tIG1haWwt
cWsxLWYxOTMuZ29vZ2xlLmNvbSAoWzIwOS44NS4yMjIuMTkzXTozNDIzNCAiRUhMTwogICAgICAg
IG1haWwtcWsxLWYxOTMuZ29vZ2xlLmNvbSIgcmhvc3QtZmxhZ3MtT0stT0stT0stT0spIGJ5IHZn
ZXIua2VybmVsLm9yZwogICAgICAgIHdpdGggRVNNVFAgaWQgUzE3MjYyMDFBYmdEQkZrUiAoT1JD
UFQKICAgICAgICA8cmZjODIyO2xpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZz4pOwogICAg
ICAgIFRodSwgMiBBcHIgMjAyMCAwMTo0MDoxNyAtMDQwMApSZWNlaXZlZDogYnkgbWFpbC1xazEt
ZjE5My5nb29nbGUuY29tIHdpdGggU01UUCBpZCBpNnNvMjgxNDE0OXFrZS4xOwogICAgICAgIFdl
ZCwgMDEgQXByIDIwMjAgMjI6NDA6MTYgLTA3MDAgKFBEVCkKREtJTS1TaWduYXR1cmU6IHY9MTsg
YT1yc2Etc2hhMjU2OyBjPXJlbGF4ZWQvcmVsYXhlZDsKICAgICAgICBkPWdtYWlsLmNvbTsgcz0y
MDE2MTAyNTsKICAgICAgICBoPXNlbmRlcjpmcm9tOnRvOmNjOnN1YmplY3Q6ZGF0ZTptZXNzYWdl
LWlkOm1pbWUtdmVyc2lvbgogICAgICAgICA6Y29udGVudC10cmFuc2Zlci1lbmNvZGluZzsKICAg
ICAgICBiaD1IajlocU5jTUUyb0lLSXcrNVZ4M3hHRFhHYmFGWjRvdlArdGh1ZkdBVm1VPTsKICAg
ICAgICBiPW9HZ1JpQ3lHTTFOdHR6SU96WDRsd2ZXYUxWV2xWTkpWeGkzcDJKMzJmOHI1QnJQTmFy
Vzh2eC9ZbDZpTFpnNUhVLwogICAgICAgICB5MW43WmxDaGdjTXpmNkNCa1pxYk1vREJMWEpjUXpL
WGtpK1pVRjdKb1hGTjRVWFhTOHFKNFhNRzFEeTVoSklQM0QycQogICAgICAgICBQeElXdTVKejk2
bWpwUCtqVEpkZjh5Nm9oV1dxVlFZR1JFKzFCdWgxeFRUaGE1YU5tZHR0VVFvN3ZoVnkrbVFDLy9Y
cwogICAgICAgICBMRXVHcCttK2ZKR2VBc3d3ckxhSnpOOWl1U0VyTTRMUmV4SE9HUGwyMUFWUzFm
eGJVTDB5UVdORy85TllFSS93eDFCNgogICAgICAgICBzTE9DdDVjVTR4QldtYzk5Wm11OWxwV0xw
dTRNUVJJYm1Kc1NlQjh2SSt1NlpoeWk5VzFHQXlnVUVQaDVyUDZEdzFpdQogICAgICAgICBZRXZ3
PT0KWC1Hb29nbGUtREtJTS1TaWduYXR1cmU6IHY9MTsgYT1yc2Etc2hhMjU2OyBjPXJlbGF4ZWQv
cmVsYXhlZDsKICAgICAgICBkPTFlMTAwLm5ldDsgcz0yMDE2MTAyNTsKICAgICAgICBoPXgtZ20t
bWVzc2FnZS1zdGF0ZTpzZW5kZXI6ZnJvbTp0bzpjYzpzdWJqZWN0OmRhdGU6bWVzc2FnZS1pZAog
ICAgICAgICA6bWltZS12ZXJzaW9uOmNvbnRlbnQtdHJhbnNmZXItZW5jb2Rpbmc7CiAgICAgICAg
Ymg9SGo5aHFOY01FMm9JS0l3KzVWeDN4R0RYR2JhRlo0b3ZQK3RodWZHQVZtVT07CiAgICAgICAg
Yj1TbWlmKzhSSExLZDFuV1ExR0RURVJmU0loTlI3azRaN0pIeHdWdEY3V2xRZ2hONktiS1IzZ2tQ
V3VHa1NiYWNUMy8KICAgICAgICAgNERZejEyN1dUNGJTSW5RclN2K3F0aytYMTJSamNCaU1sb3Z2
NXBITmVsS0Q2aTFhMWFQOXhaRm8wTFR3VDg2MEhLeDEKICAgICAgICAgeTZxeElIdk9ieC9HaGVT
NGowdTNvZ3VzMHVOekV2VG5sSXB0TlFoQTNpZnd2UU5iRGg4Q3VKV2FlUVZ2TkIyOXNpMXYKICAg
ICAgICAgN2tOVjhpdmhMUExwR0E5OUlBamdBMDh3Z1JPUUQ2OFFDL1NwRWFoeEcyTHpFRzBkSVRS
TVVlRm9IQXEvNVlZQnVCeTUKICAgICAgICAgOE94RWZzUjBHM1NxZHFMWWw4cW51UkZGcGl4aCsr
TjJYS3BEaHFQMjNZMjVVM1VaZlZSWWl4eHBWVEdDcUpocXhLV1EKICAgICAgICAgRkVRQT09Clgt
R20tTWVzc2FnZS1TdGF0ZTogQUdpMFB1YnNJaXJ6cFRwL2d0ZnBvb2NMcEdFcVVIV1o2SDRvQzJK
VCtmT3NFd1dKRVA3bUNQS08KICAgICAgICBHcFV5djhSNjJRdVo5SkZpb1dWVWordTlZa3R2Clgt
R29vZ2xlLVNtdHAtU291cmNlOiAKIEFQaVF5cEtZUXp3VENhdVNDWnNOekZ3UDdwU0FiZjQzRmpH
cUhpQm4vbENuRWhBYk8reklVMVJ5WThSTFg5TXV6dHhySkhTS3NmenllZz09ClgtUmVjZWl2ZWQ6
IGJ5IDIwMDI6YTM3OjRjNGQ6OiB3aXRoIFNNVFAgaWQgejc0bXIxODQyOTg3cWthLjUzLjE1ODU4
MDYwMTU2NjY7CiAgICAgICAgV2VkLCAwMSBBcHIgMjAyMCAyMjo0MDoxNSAtMDcwMCAoUERUKQpS
ZWNlaXZlZDogZnJvbSBsb2NhbGhvc3QgKGMtNzMtNzQtNy05LmhzZDEuaWwuY29tY2FzdC5uZXQu
IFs3My43NC43LjldKQogICAgICAgIGJ5IHNtdHAuZ21haWwuY29tIHdpdGggRVNNVFBTQSBpZAog
dDE0MHNtMjkxMTQ1OXFrZS40OC4yMDIwLjA0LjAxLjIyLjQwLjEzCiAgICAgICAgKHZlcnNpb249
VExTMV8zIGNpcGhlcj1UTFNfQUVTXzI1Nl9HQ01fU0hBMzg0IGJpdHM9MjU2LzI1Nik7CiAgICAg
ICAgV2VkLCAwMSBBcHIgMjAyMCAyMjo0MDoxNCAtMDcwMCAoUERUKQpSZWNlaXZlZDogZnJvbSBs
b2NhbGhvc3QgKGxvY2FsaG9zdCBbMTI3LjAuMC4xXSkKICAgICAgICBieSBsb2NhbGhvc3QgKDgu
MTUuMi84LjE0LjkpIHdpdGggRVNNVFAgaWQgMDMyNWVBT2MwMDU5MDQ7CiAgICAgICAgVGh1LCAy
IEFwciAyMDIwIDAwOjQwOjEyIC0wNTAwClJlY2VpdmVkOiAoZnJvbSBjaHJpc0Bsb2NhbGhvc3Qp
CiAgICAgICAgYnkgbG9jYWxob3N0ICg4LjE1LjIvOC4xNS4yL1N1Ym1pdCkgaWQgMDMyNTRLWTMw
MDQ4ODc7CiAgICAgICAgVGh1LCAyIEFwciAyMDIwIDAwOjA0OjIwIC0wNTAwCkZyb206IENocmlz
IFJvcnZpY2sgPGNocmlzQHJvcnZpY2suY29tPgpUbzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJu
ZWwub3JnLCBuZXRkZXZAdmdlci5rZXJuZWwub3JnLAogICAgICAgIGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmcKQ2M6IENocmlzIFJvcnZpY2sgPGNocmlzQHJvcnZpY2suY29tPiwKICAgICAg
ICBKb2hhbm5lcyBCZXJnIDxqb2hhbm5lcy5iZXJnQGludGVsLmNvbT4sCiAgICAgICAgRW1tYW51
ZWwgR3J1bWJhY2ggPGVtbWFudWVsLmdydW1iYWNoQGludGVsLmNvbT4sCiAgICAgICAgTHVjYSBD
b2VsaG8gPGx1Y2lhbm8uY29lbGhvQGludGVsLmNvbT4sCiAgICAgICAgSW50ZWwgTGludXggV2ly
ZWxlc3MgPGxpbnV4d2lmaUBpbnRlbC5jb20+LAogICAgICAgIEthbGxlIFZhbG8gPGt2YWxvQGNv
ZGVhdXJvcmEub3JnPiwKICAgICAgICAiRGF2aWQgUy4gTWlsbGVyIiA8ZGF2ZW1AZGF2ZW1sb2Z0
Lm5ldD4KU3ViamVjdDogW1BBVENIXSBpd2x3aWZpOiBhY3R1YWxseSBjaGVjayBhbGxvY2F0ZWQg
Y29uZl90bHYgcG9pbnRlcgpEYXRlOiBUaHUsICAyIEFwciAyMDIwIDAwOjAyOjE5IC0wNTAwCk1l
c3NhZ2UtSWQ6IDwyMDIwMDQwMjA1MDIxOS40ODQyLTEtY2hyaXNAcm9ydmljay5jb20+ClgtTWFp
bGVyOiBnaXQtc2VuZC1lbWFpbCAyLjI1LjAKTUlNRS1WZXJzaW9uOiAxLjAKU2VuZGVyOiBsaW51
eC13aXJlbGVzcy1vd25lckB2Z2VyLmtlcm5lbC5vcmcKUHJlY2VkZW5jZTogYnVsawpMaXN0LUlE
OiA8bGludXgtd2lyZWxlc3Mudmdlci5rZXJuZWwub3JnPgpYLU1haWxpbmctTGlzdDogbGludXgt
d2lyZWxlc3NAdmdlci5rZXJuZWwub3JnCgpDb21taXQgNzFiYzAzMzRhNjM3ICgiaXdsd2lmaTog
Y2hlY2sgYWxsb2NhdGVkIHBvaW50ZXIgd2hlbiBhbGxvY2F0aW5nCmNvbmZfdGx2cyIpIGF0dGVt
cHRlZCB0byBmaXggYSB0eXBvZSBpbnRyb2R1Y2VkIGJ5IGNvbW1pdCAxN2I4MDljOWIyMmUKKCJp
d2x3aWZpOiBkYmc6IG1vdmUgZGVidWcgZGF0YSB0byBhIHN0cnVjdCIpIGJ1dCBkb2VzIG5vdCBp
bXBsZW1lbnQgdGhlCmNoZWNrIGNvcnJlY3RseS4KCkZpeGVzOiA3MWJjMDMzNGE2MzcgKCJpd2x3
aWZpOiBjaGVjayBhbGxvY2F0ZWQgcG9pbnRlciB3aGVuIGFsbG9jYXRpbmcgY29uZl90bHZzIikK
VHdlZXRlZC1ieTogQGdyc2VjdXJpdHkKU2lnbmVkLW9mZi1ieTogQ2hyaXMgUm9ydmljayA8Y2hy
aXNAcm9ydmljay5jb20+Ci0tLQoKWyB2MS0+djI6CiAgLSBGaXggdHlwbyBzL2Z3LmRiZ19jb25m
X3Rsdi9mdy5kYmcuY29uZl90bHYKICAtIEFkZCBGaXhlcyB0YWcgYXMgc3VnZ2VzdGVkIGJ5IEth
bGxlCi1kaWxla3MgXQoKIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2ludGVsL2l3bHdpZmkvaXdsLWRy
di5jIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0p
CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9pd2wtZHJ2
LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL2l3bC1kcnYuYwppbmRleCBm
ZjUyZTY5YzFjODAuLmEzN2YzMzBlN2JkNCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvaW50ZWwvaXdsd2lmaS9pd2wtZHJ2LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50
ZWwvaXdsd2lmaS9pd2wtZHJ2LmMKQEAgLTE0NjUsMTEgKzE0NjUsMTEgQEAgc3RhdGljIHZvaWQg
aXdsX3JlcV9md19jYWxsYmFjayhjb25zdCBzdHJ1Y3QgZmlybXdhcmUgKnVjb2RlX3Jhdywgdm9p
ZCAqY29udGV4dCkKIAkJaWYgKHBpZWNlcy0+ZGJnX2NvbmZfdGx2W2ldKSB7CiAJCQlkcnYtPmZ3
LmRiZy5jb25mX3RsdltpXSA9CiAJCQkJa21lbWR1cChwaWVjZXMtPmRiZ19jb25mX3RsdltpXSwK
IAkJCQkJcGllY2VzLT5kYmdfY29uZl90bHZfbGVuW2ldLAogCQkJCQlHRlBfS0VSTkVMKTsKLQkJ
CWlmICghcGllY2VzLT5kYmdfY29uZl90bHZbaV0pCisJCQlpZiAoIWRydi0+ZncuZGJnLmNvbmZf
dGx2W2ldKQogCQkJCWdvdG8gb3V0X2ZyZWVfZnc7CiAJCX0KIAl9CiAKIAltZW1zZXQoJnRyaWdn
ZXJfdGx2X3N6LCAweGZmLCBzaXplb2YodHJpZ2dlcl90bHZfc3opKTsK
--00000000000030972905a33f248b--
