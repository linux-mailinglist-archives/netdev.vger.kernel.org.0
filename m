Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A04D1C326B
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 08:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgEDGC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 02:02:28 -0400
Received: from mout.web.de ([212.227.17.12]:56227 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgEDGC2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 May 2020 02:02:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1588572131;
        bh=VzTdkyAD08T61DvGRdMXtyVSqMI0D89n3sPnc+qPeXg=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=TlI2YE31VFBaW70FsVWiN9MHOVTW4Z894A3DS91GW369m02tNi9nOGmDe0mkjIj4o
         nCp63mXTqvE8Zt72kZYAWmJcEqapUa695NSi7BTK0/QdmTWYg/NxVU6pgAgaQvguQ8
         RFI4u2RH095TcTzLpfEDE6H3OvOBVVuLXRrtghrM=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.133.152.69]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MX0YK-1jhdF03naG-00VzSC; Mon, 04
 May 2020 08:02:11 +0200
Subject: Re: [PATCH v3] nfp: abm: Fix incomplete release of system resources
 in nfp_abm_vnic_set_mac()
To:     Qiushi Wu <wu000273@umn.edu>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Cc:     oss-drivers@netronome.com, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, Kangjie Lu <kjlu@umn.edu>
References: <20200503204932.11167-1-wu000273@umn.edu>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <265a25f7-6ef1-1387-d60a-9ffe8ccfbd73@web.de>
Date:   Mon, 4 May 2020 08:01:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200503204932.11167-1-wu000273@umn.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:AvXDT0o/ikXfL38quRh8+24/gaW0HKkjufaX4AXzE7TDRVA80m0
 QQcWwRwI7CvNRTOtX5SH6GNu+bmrZLyZYBLjtCVbbJRZJefTcl9pelHnlK7KGs9KRU+b7MA
 oL1wssaT+LyZxJOOzUxYud8Svw+Gts0xpMo5l2JMpkGbcEk9N6QB50CKJGtUMoUwJoJeiU0
 7aqbYDVixFvwj09G0EaRw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ebZw7HG1iVM=:oeihwbmQomtzBFPf6Fk8j/
 r/xegseR6mOQD52eq19nn/pNRjYxqFH1Rzq6lsqxMNvkOe0XAzPNMJx40thCa1h4caLZ5SiFc
 mwPkPzwPYQlsZ183+yaqFHTsM2mEyBqsGRbj116Xict9hg2Kmhg4PBGmiNm3uVAv75LzAM3lb
 9dLh9xDu909jDnEXwPKFRT4AC7GMYcUko99aHSNLXRRUvSAvxGCKkTUz5za4NBZUpDZGzDhOc
 8iCJSz5XRnvvDwHSiZa1QB2Gt+TLYPSlmEIRnFOKihKdd2irRSZIZVu96dkKjBoALZyItluwx
 nN+0AWT9ng3WtBZYJmqi8RHXZItR9q3Wp8wrgfGYfcXe7CGJpHfFpzoVxwIAGdHytGLVOK/5h
 C521AiX7v/eF3AePwRgKAwOtYlE7ozKpFzMEJryPDK/I7eJm3ONYp6KTo6R+Q4V5DO3wOO+t4
 IDfnvoLNi0INEket753Vgm8KWBev5yirmFZcZ9l+gN9a63+klDTg1joHNr1fwtNQHmT/Io4+p
 otzfMnOUzhTi8KwzEOQBO+/OuFUEGBpBPQzLL2rwg5Up55/h3Y870AFPOCcHJdZGOmFsgVazr
 YycW1NQenWEA6WDaya5RvqPc+A6ycPPQ+eeBgjdzJdB3ZXDNi9pr0/pjgSmIjgJ04aDLsWRsz
 Pd5rmR/LAdmT56aAVSUrqi/EcaZc3zAaoMlmcVCUz5ZCOfHLXafcWnGkdGyPsknCPFNLnN9Po
 MeeQE2YpNn5ohy5Uxu1PCv4kqWVttfjM04kvCBmvXh56CPlo8AWKoSMLD91/b85wzZZXOjU6v
 /Twl+WZUfk5qPCadbrHKbyaV9E/As4UdQF4KjPB3YkXHxwMou87GOXHac9lJxqIzGG62azjrT
 zt6V3jP/1v3FEAMkC3Vmy9n1XFph4ARQxEqz2nMMm3vh+ME7ZXtOkdVeOe4mA8QMRlUePFsC2
 /X+lmy/wMh/g4rtbSw6QXy2/tOVC5k68Iv3wc44fKRUDMIwQo7ctbIEhijlPFRo5tfAU6vHWn
 8I4H7vq64eb2x7NALt7xrDF1SkLAPZcr7Wnw9FPLtuH21F76w/rd91RAe1Efdmjm8G5Tx2hkp
 A1ZXEONI/577EwJP0NBuWVd2ZXulhd80wEIJPvuOi33423vFTo5vhJOMVB+rI/ywei1wapE/u
 0bDXVswxvm5sN+vTU/4TJGSZRMh3yoiSO56Idfa9oMFcJDlqCNIEwh3Ac55i7sGI6yuHZb5K2
 eblermRJjO0UfHce3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> =E2=80=A6 Thus add a call of the function
> =E2=80=9Cnfp_nsp_close=E2=80=9D for the completion of the exception hand=
ling.

I suggest to mention also the addition of a jump target because of
a Linux coding style concern.


=E2=80=A6
> +++ b/drivers/net/ethernet/netronome/nfp/abm/main.c
=E2=80=A6
> @@ -300,12 +297,16 @@ nfp_abm_vnic_set_mac(struct nfp_pf *pf, struct nfp=
_abm *abm, struct nfp_net *nn,
=E2=80=A6
> +generate_random_address:
> +	eth_hw_addr_random(nn->dp.netdev);
> +	return;
>  }
=E2=80=A6

I recommend to apply the check =E2=80=9CRETURN_VOID=E2=80=9D once more.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/sc=
ripts/checkpatch.pl?id=3D0e698dfa282211e414076f9dc7e83c1c288314fd#n4866

Regards,
Markus
