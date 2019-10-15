Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3569D73C9
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 12:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731372AbfJOKtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 06:49:07 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40738 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731088AbfJOKtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 06:49:06 -0400
Received: by mail-wm1-f67.google.com with SMTP id b24so19744704wmj.5
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 03:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=date:in-reply-to:references:mime-version:content-transfer-encoding
         :subject:to:cc:from:message-id;
        bh=vb+V5G1fB6s4se4aNOPSNT85ySMUe6CSa81Te8JBoRE=;
        b=Ws9ob7nauEn+3EsJY6I5+GXnH49DvTwHXX/MxLUJ3LY8uxK868wT+FZpNOmdrNlOgT
         xkdZCWfJ6AiUBpIoNJm5/bjk09IK4XLr+8YirI5DC0dOgbs//TjihQtEVMK8ymCVAWQ6
         v1pEcVGEFGd+XsMDjbejhcZ+W0iUpyWyU/DtQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=vb+V5G1fB6s4se4aNOPSNT85ySMUe6CSa81Te8JBoRE=;
        b=dwo2dbnTHGMSE6ngpW/3s9HkIBG6+nahUEU+GBCJ9uSUb7hBzJCGFAA5fxUWQ331XE
         h9d8CsswLlqvSZJLS/rMt6RseXRf/SZptwQpzsOyshxllWu+AVDfewre7ffBLFLbWDBj
         uoF/KQR+CZlee+U7YfXnHq1t5jxWKlEIs6Cj4aybFGqGTJEX0VZZN5ECD4UUD0Ul+Frq
         pREGs/VI+rYRPGL50XXwdh0lLpUruEB1EX04augpwNRJE0zoFqrvlbZp/yA4ohYtVeno
         x4DENkXz4gSE/3s7DMjFaqwMz7jcm598zoDol/PoDNkvhpgMxOCxRcHSPhWd1TJdzG7e
         4M8w==
X-Gm-Message-State: APjAAAVVvdUKceqeb+KGj2z3DgIJORw0pLdqOsedNeT8XMBGyowtK0FL
        klQd2eWQdR20/C+u2A1JBR1Rrg==
X-Google-Smtp-Source: APXvYqxqk+PcUuGuepeG7DFxASrTImgJnXo3yNaAx+CI3Nc2GiDWOYAG0mPq2KL1TrVGJjEXPEAOGA==
X-Received: by 2002:a7b:ca4b:: with SMTP id m11mr18075692wml.129.1571136544210;
        Tue, 15 Oct 2019 03:49:04 -0700 (PDT)
Received: from localhost ([149.62.203.53])
        by smtp.gmail.com with ESMTPSA id s1sm30565484wrg.80.2019.10.15.03.49.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 03:49:03 -0700 (PDT)
Date:   Tue, 15 Oct 2019 12:48:58 +0200
In-Reply-To: <CAFLxGvwnOi6dSq5yLM78XskweQOY6aPbRt==G9wv5qS+dfj8bw@mail.gmail.com>
References: <CAFLxGvwnOi6dSq5yLM78XskweQOY6aPbRt==G9wv5qS+dfj8bw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: Bridge port userspace events broken?
To:     Richard Weinberger <richard.weinberger@gmail.com>,
        netdev@vger.kernel.org
CC:     Roopa Prabhu <roopa@cumulusnetworks.com>,
        bridge@lists.linux-foundation.org,
        Greg KH <gregkh@linuxfoundation.org>
From:   nikolay@cumulusnetworks.com
Message-ID: <3A7BDEE0-7C07-4F23-BA01-F32AD41451BB@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14 October 2019 22:33:22 CEST, Richard Weinberger <richard=2Eweinberger@=
gmail=2Ecom> wrote:
>Hi!
>
>My userspace needs /sys/class/net/eth0/brport/group_fwd_mask, so I set
>up udev rules
>to wait for the sysfs file=2E
>Without luck=2E
>Also "udevadm monitor" does not show any event related to
>/sys/class/net/eth0/brport when I assign eth0 to a bridge=2E
>
>First I thought that the bridge code just misses to emit some events
>but
>br_add_if() calls kobject_uevent() which is good=2E
>
>Greg gave me the hint that the bridge code might not use the kobject
>model
>correctly=2E
>
>Enabling kobjekt debugging shows that all events are dropped:
>[   36=2E904602] device eth0 entered promiscuous mode
>[   36=2E904786] kobject: 'brport' (0000000028a47e33): kobject_uevent_env
>[   36=2E904789] kobject: 'brport' (0000000028a47e33):
>kobject_uevent_env: filter function caused the event to drop!
>
>If I understood Greg correctly this is because the bridge code uses
>plain kobjects which
>have a parent object=2E Therefore all events are dropped=2E
>
>Shouldn't brport be a kset just like net_device->queues_kset?


Hi Richard,=20
I'm currently traveling and will be out of reach until mid-next week when =
I'll be
able to take a closer look, but one thing which comes to mind is that on
any bridge/port option change there should also be a netlink notification =
which
you could use=2E I'll look into this and will probably cook a fix, if anyo=
ne hasn't
beaten me to it by then=2E :)=20

Cheers,
  Nik
