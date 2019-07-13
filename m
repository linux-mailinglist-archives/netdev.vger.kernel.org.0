Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 085F067737
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 02:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727492AbfGMA1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 20:27:12 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:34892 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727392AbfGMA1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 20:27:12 -0400
Received: by mail-qk1-f196.google.com with SMTP id r21so7812850qke.2
        for <netdev@vger.kernel.org>; Fri, 12 Jul 2019 17:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/b1FhYxov1no8AIqKnTicBtEIZykZHc9EwDW+pUQyt0=;
        b=cXPQ2Qf1eeSNA2EGxwYad+zRzfzIhNuRdIqiEzoYXeH2TemMl0NTmLV4X/TQ+izKoW
         uxAWH5D1ie7TtLCRI/OJNORV/fB/1w+W9N8QZvyRIkuQo0GpNmQv4cpi+js8WQ+7Xu6n
         zUVOTJbLjqT7MM0zDbvrOIkjplJQnBiAkCB7S2Au16N+gUOkQQmvZ4kQqnze8OJ8qgxp
         2NPv/OR+jRLlTLe8mt0pm3LQVzikg7xES8qOgoI0VNTK7sktDMgAN/1Jod6vFjsU5BXh
         TAFHbvLi0fsN/qSmuk8RGwzCtUyOwBPOSJXKGsSkxkJcnjn38I4IXf9EVPGf1rJxFcaD
         0JTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=/b1FhYxov1no8AIqKnTicBtEIZykZHc9EwDW+pUQyt0=;
        b=KrlrvZQB0meQ4dPbBA4QgEqfyPRiUGtlFkc6Qasm7jrrlYCpOqh96yabTpqlzgpH3P
         BZVmUwuaPwU9cZZbmtBUVSZUfM/cF7V/J1ICL9XQ392m99c1jD5Ovti8v8/3VpVucQtW
         itn05JQapqwg9Pg/yV37C2eHrI1yKKUfmWxy31nA+NjS2CzWXt0p8vKsIh8uvVEdgbOZ
         37UKzz8vEXmPSY4RefC7M4SXWP3euWvTQtwWTbt5Ic1lPMX85Lu2VU7ufGxlyzRICV50
         YZxiE5kfzXcZJxc0Wip7ZgB1Ohj1RJHV+lc0B8QsAQlYDt8pfzZIcjBfav1LcNYgF3hu
         yG3w==
X-Gm-Message-State: APjAAAVHDNr3ULtOcAS5DY7f8oy2EKPXJKap15sCdbiRpBHzv/yq8V9m
        Pct8LXgFmE04tcRuT9IWiQG1mw==
X-Google-Smtp-Source: APXvYqxe5GNimyT2mRnWHw7NTML9DguxquzhqvGrNJEFRydui+CrARbyZoVGFEouI3krFFd9HhaKKA==
X-Received: by 2002:a37:a692:: with SMTP id p140mr8197020qke.432.1562977631518;
        Fri, 12 Jul 2019 17:27:11 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id d31sm5467712qta.39.2019.07.12.17.27.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Jul 2019 17:27:10 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH] be2net: fix adapter->big_page_size miscaculation
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <20190712.154606.493382088615011132.davem@davemloft.net>
Date:   Fri, 12 Jul 2019 20:27:09 -0400
Cc:     sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        arnd@arndb.de, dhowells@redhat.com, hpa@zytor.com,
        netdev@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EFD25845-097A-46B1-9C1A-02458883E4DA@lca.pw>
References: <1562959401-19815-1-git-send-email-cai@lca.pw>
 <20190712.154606.493382088615011132.davem@davemloft.net>
To:     David Miller <davem@davemloft.net>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jul 12, 2019, at 6:46 PM, David Miller <davem@davemloft.net> wrote:
>=20
> From: Qian Cai <cai@lca.pw>
> Date: Fri, 12 Jul 2019 15:23:21 -0400
>=20
>> The commit d66acc39c7ce ("bitops: Optimise get_order()") introduced a
>> problem for the be2net driver as "rx_frag_size" could be a module
>> parameter that can be changed while loading the module.
>=20
> Why is this a problem?

Well, for example, if rx_frag_size was set to 8096 when loading the =
module, the kernel has already used the default value 2048 during =
compilation time.

>=20
>> That commit checks __builtin_constant_p() first in get_order() which
>> cause "adapter->big_page_size" to be assigned a value based on the
>> the default "rx_frag_size" value at the compilation time. It also
>> generate a compilation warning,
>=20
> rx_frag_size is not a constant, therefore the __builtin_constant_p()
> test should not pass.
>=20
> This explanation doesn't seem valid.

Actually, GCC would consider it a const with -O2 optimized level because =
it found that it was never modified and it does not understand it is a =
module parameter. Considering the following code.

# cat const.c=20
#include <stdio.h>

static int a =3D 1;

int main(void)
{
	if (__builtin_constant_p(a))
		printf("a is a const.\n");

	return 0;
}

# gcc -O2 const.c -o const

# ./const=20
a is a const.=
