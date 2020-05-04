Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E42E1C33B1
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 09:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgEDHfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 03:35:15 -0400
Received: from mout.web.de ([212.227.17.12]:60699 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726411AbgEDHfO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 03:35:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588577698;
        bh=Lc0faecF8W7GIx3lwoXf7ntUgwhs1pxSj95JFscvDIU=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=nrh56QJ3cRbqn7lpfhJ7jfNUkOm1bqJKd61NzNLKctRZ9OH8bu0DAL3nxsDwx1DbH
         OexYdjgjDuqTSzp9cbs6KafZHgRB5UGK5i+T5ZqwKIe6n8meL1PvPMqvML/UQ/V5/a
         FwpE45pWV9RGKr0XZMOhmkMXeSEKgp8WB3a1OxTM=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.152.69]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MPaMS-1jquOp3ZBq-00MoXj; Mon, 04
 May 2020 09:34:57 +0200
Subject: Re: [PATCH v3] nfp: abm: Fix incomplete release of system resources
 in nfp_abm_vnic_set_mac()
To:     Qiushi Wu <wu000273@umn.edu>, netdev@vger.kernel.org
Cc:     oss-drivers@netronome.com, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Kangjie Lu <kjlu@umn.edu>
References: <20200503204932.11167-1-wu000273@umn.edu>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <2a5f2e6e-2553-ce92-9cbc-02f5bd2ce8fa@web.de>
Date:   Mon, 4 May 2020 09:34:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200503204932.11167-1-wu000273@umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Zjcz3AKRdMP9jtINqKIkLdZHKYrenXikA/23PvEaMdzRE+dwgLj
 YdTvmsrAfpXs4GjyhXOhxS/XDAZK2Eug5FwAyGloO1k3+ju91nLebQ2ibNwNhu/QWo68JXD
 t6Hi9t5CR3e8y0wm8ebtwdM26/utXIi4tS4snWJl9B/BOFGKkQ2TEnDtmdrgAWkuAUxFtC9
 cfsGjD+2h+xSuadFR58Xw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NWIBaFlkwnM=:hOL4rzZLL/N/+X1jepIGSX
 B/GEvYeBHZE87v6mdz81ZeDumeftyf/yk+GQiZdSaiW5kzIQZP8nakoV12YjZAwbBLvOGIdh0
 CJfvedjUHpWW2RuxRhVCS+tuHxlOfafeCbz85mHSVar5VeH0tgOF1u6rx+RGJWWuEYG61+QAm
 BmO1r6cHLq4xA+m9/tKpg2Gnl2rIZij0G1BoI/gp9NHf4FX5uV1Ycn1dBEraCKYrwgAiljaBz
 izWtUbcG6gQ60XH4aJDDUfsjQvwbCAxDlJYGOwYxwx2FauhWEWCQmW91JJTWY0hxbXIw1QC66
 cBDbf0So6kOasT6tFBoJyENYFK4urJlPsef37JuQbIm/jtckNHfkrvM/7z4uKCSorpYWyWrku
 GjwRoKzSMXvAnBaTDJ/pn2/xR+hLYgu7JHG944ZtZEt+O6N0xpsZTo52rDZi8alGoyRgFruIC
 ryDHWY3FTu6AjFUQjOoeuRXM3GSW/bXr6PYmNSK6cy3S29UUy2sXBsr6132y6MakHiPy0oZUu
 9GGKJYjKvOm8Zc5xKjFRRlUeA1h/xqL1OnRrtu2Xa3d2QyAFRvzYmgdHJ+RMx0SeRFbZwHyQx
 fSGiMvoS9iJ59t08MUyksBVIcsLf8Ud2j7TWWKG4V9WuiH5X8QHkZfqhR9M5OJyezBF/ldedf
 tBcNqJ9WJpogoV8aRt47wZ0EXPpENgQrWj476jbgMnTTYD9gnUES34W3A/4VmxD3ERBO+ZBlf
 VLiM8I5uFN2bXPJM/jxMZVjn0cDQgoNnuqczNETv18E8eSd6SW12s4sWdzvOUOZyxAEgpLwYV
 LxStH8b7cxIIM0XTV9snl8ZZMsXx1blVVGlpuGFDxxz3roplJtd2fb2JpVjCVB2Mp1RNl/UgL
 LW22u8sJ7wfTXiw/hR3jfQtNFsNwJA9SYYc4sPn2LVesxBaW8YNlurNu/RJaGYRwhvQOr0Ynn
 jSBpBvbY2152Ury8wm+m6Zbmm/nPslYGajrwKIVR8blZh8853OGb5ufVFtYhFcCDi8Pojr+IF
 Izto8LtUYlYyKvbH6b8ib4J9VR0O2kerBeMaiL1ihqGgT/HVpuqAtYEeZdXNYLWeHPLGoLtaV
 HUb/vRImPkOoHVWBvw9fEyBb0W+OlM2K1EaTO8IYX7A3NrBzZrRyfW8cxLsL+0BxZikR3hBjC
 wR+Kwc3Yy3UJKHpf5V4jFHIiDEr6vnPwee1G+rqyfLH6lh/m0m7TKqrt6MJyU5oSwjUrpgFxI
 ua9vPysZW6EPI0TOc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> But when nfp_nsp_has_hwinfo_lookup fail, the pointer is not released,

Do you distinguish between releasing items and the role of such a pointer?


> which can lead to a memory leak bug.

Would you like to reconsider the usage of the word =E2=80=9Ccan=E2=80=9D f=
or
such change descriptions?

Regards,
Markus
