Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A245E133EE9
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 11:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgAHKIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 05:08:51 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41779 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726368AbgAHKIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 05:08:51 -0500
Received: by mail-qk1-f196.google.com with SMTP id x129so2077202qke.8;
        Wed, 08 Jan 2020 02:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wBde31pOaHu2+f2qm9/eIeV88gEPcS+I0k40/vOG3No=;
        b=LAPfP59xeUBncwBGWmNecuY8RsrUoLOkqTkNaLxpDmYWdFnsZcovbY0uQ9DVM8ej+u
         L2rzOq6NywM7bkI4t2yZdrTaYjhXg9FGSEBR03uDgOW8llUYXI0fiKWJBAqg0EQK7MIS
         30RqxToyYCkswcqF2KGvmldEhtYp541dNTFeuKGneJvyhvsveNWtK8ZSdtmtWts/R1RN
         vTsrBWeTsr3wepZoIe/QMwsUpQ+A9to1aQ69SyJe+IE0+y8O2C3QQ88FTJvBaU1RpTSo
         QUxuaPwU4qJjle631JmddhgR59Qh7I6kn0GjAj0bM+/zZZdAgC/n1oMH+TQ//cp5yvoz
         do5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wBde31pOaHu2+f2qm9/eIeV88gEPcS+I0k40/vOG3No=;
        b=nM++/FOYn8lpTe5AOdJvxBvuKi9Qlf9xCU5Z5k9piXNXYFQQWcUMchF6G33EnU85w6
         8N/l97ahSdn1HW/eS/hM/J/FYPRYe3cp4DBfEMNOH8GE2Ye/pbycIEyMHVKNU6mr7fgl
         U+7/qtsvpDaXTS2LT/1pV8yL/9YvhsM6m8mI+tug/X/mvCmbXRcy1TxmPvDglUedWVCe
         HCYUp+d1POZrtHvFsptjPCiQQzKiU8RmhDms2fJAgjecpesyQx10mPxKxDXA/64ZNIze
         Edgbt31aSy7jaaAFrlbmtSpdkMjCoOJoXsdfY97FBUZsdiAUDdU9zcZeDxXRxv7yYCau
         aliw==
X-Gm-Message-State: APjAAAUbi3D17u0OskP57HlSb2yRFSBzs6lMjgkFrWxLoroLP0Fj67wn
        XDwWjGh7MWH5re3SpS7aC6c7a7E/gBjXQTGNI8s=
X-Google-Smtp-Source: APXvYqzku5S8giw4+5MFRoRnPOXswGdVZTq7CO/oQ8D1Qsk1YkuLn7soYLp+A9f4Ujw9SoRAozhNFO4J4wWncjRpDAc=
X-Received: by 2002:a05:620a:14a4:: with SMTP id x4mr3442285qkj.493.1578478130146;
 Wed, 08 Jan 2020 02:08:50 -0800 (PST)
MIME-Version: 1.0
References: <20191219061006.21980-1-bjorn.topel@gmail.com> <20191219061006.21980-2-bjorn.topel@gmail.com>
 <5e14c0b1740ca_67962afd051fc5c0a5@john-XPS-13-9370.notmuch>
In-Reply-To: <5e14c0b1740ca_67962afd051fc5c0a5@john-XPS-13-9370.notmuch>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 8 Jan 2020 11:08:39 +0100
Message-ID: <CAJ+HfNh3PkqRCp7=WT3GBhNwtPR-idLX4D8wH0R=B4+_GLNWLA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/8] xdp: simplify devmap cleanup
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jan 2020 at 18:32, John Fastabend <john.fastabend@gmail.com> wrot=
e:
>
[...]
>
> Otherwise LGTM thanks.

Thanks for the review, John! I'll update the comments in a follow-up!


Bj=C3=B6rn
