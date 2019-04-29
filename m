Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23967EB49
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 22:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729380AbfD2UCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 16:02:00 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44603 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729229AbfD2UCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 16:02:00 -0400
Received: by mail-pf1-f193.google.com with SMTP id y13so5847455pfm.11
        for <netdev@vger.kernel.org>; Mon, 29 Apr 2019 13:02:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=n3iKxa+4/Y8ghD3yFm+F3jT4Iz1b+JS2aEY2Qy+Qchk=;
        b=meYEu8lj99lYWHuC3D7tQV2qNDcATM5x+wSJnG583MtSAxODlewcjfj/NCZwXjAqpg
         CcNeuHqWQkgXJfZX0qOc28XhuYY7fftz67DTpjp1y/G+rV3ZTlo4nFrQBRzYcWSJkazm
         ZnRPok/rzD0ChPThEmywkTDKGlGm197iSyIgw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=n3iKxa+4/Y8ghD3yFm+F3jT4Iz1b+JS2aEY2Qy+Qchk=;
        b=GsDikEPARvYdqrHQ7921pUeW+Z8IEsZjsCQmSx5AZtfNthcJ1fh1SC96uTZksRdGif
         t4OyQudY0A9PoaqZRTJOFKWnEPUAoNgdIhtn4vqfef2dsJFe2wiN9DBXRghQ2jgiB7Bw
         v+SlfpJT3XlwVdlQoaJcWjbUSBth90UCdjieIl/LTGH74Nj4NIvePSXBn1xZETl/d8hS
         HS/WMZRUj/Z+9TuPLIy+GpVFCppeN2ZU/+biS9Tf9pn/+tCeXEbz7bN7NnB6RuPuSaGX
         kacMxZzahc10sBIg8zyucCSy48MLNwR6rrmdL6zl3uULbcq8bT1lIW/co7rMOb8T4q/e
         pDfw==
X-Gm-Message-State: APjAAAVvXh2vflQSazTdXWumZhZE1pXH0/82MQofgqmdO1dv6g4z01qf
        Qvf8aM03NVnhH+NmiqXCjxHI
X-Google-Smtp-Source: APXvYqxbgAk6T3Vn+nrQdmHuwR5M8xdMbKp1Q4a0zLguAUTsL2r3tIBtDZt2m0LJLABrxn1tDBTmtg==
X-Received: by 2002:a63:4c26:: with SMTP id z38mr62557696pga.425.1556568119807;
        Mon, 29 Apr 2019 13:01:59 -0700 (PDT)
Received: from [192.168.1.90] (d173-180-161-165.bchsia.telus.net. [173.180.161.165])
        by smtp.gmail.com with ESMTPSA id s9sm45375213pfe.183.2019.04.29.13.01.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Apr 2019 13:01:59 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Re: [net-next 01/12] i40e: replace switch-statement to speed-up
 retpoline-enabled builds
From:   Josh Elsasser <jelsasser@appneta.com>
In-Reply-To: <20190429191628.31212-2-jeffrey.t.kirsher@intel.com>
Date:   Mon, 29 Apr 2019 13:01:57 -0700
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6C3E4204-AABF-45AD-B32D-62CB50391D89@appneta.com>
References: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
 <20190429191628.31212-2-jeffrey.t.kirsher@intel.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
X-Mailer: Apple Mail (2.3445.102.3)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Apr 29, 2019, at 12:16 PM, Jeff Kirsher <jeffrey.t.kirsher@intel.com> =
wrote:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> GCC will generate jump tables for switch-statements with more than 5
> case statements. An entry into the jump table is an indirect call,
> which means that for CONFIG_RETPOLINE builds, this is rather
> expensive.
>=20
> This commit replaces the switch-statement that acts on the XDP program
> result with an if-clause.

Apologies for the noise, but is this patch still required after the
recent threshold bump[0] and later removal[1] of switch-case jump
table generation when building with CONFIG_RETPOLINE?

[0]: https://lore.kernel.org/patchwork/patch/1044863/
[1]: https://lore.kernel.org/patchwork/patch/1054472/

If nothing else the commit message no longer seems accurate.

Regards,
-- Josh=
