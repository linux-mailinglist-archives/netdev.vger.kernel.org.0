Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2813C3A402D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 12:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhFKKcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 06:32:05 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:45639 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhFKKcD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 06:32:03 -0400
Received: by mail-ot1-f48.google.com with SMTP id 6-20020a9d07860000b02903e83bf8f8fcso2643198oto.12
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 03:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=PTMzXA/YgDw0MB3J+5E7hzqxaAkfuwn6Ly5vzSypvxo=;
        b=cx/Q/WIBubQEKyCeZsqmDJICKWtmBhgVx9aEULnioNkur6Zh0VYlzUiD3rkEciH9RP
         zV7YVqBtOOS6kshS68IxH3pmVrZwGKqeaa+mQLCEoElgckFNtKHo2A5cNk6ZwvPAiPg9
         6/7YbME8PLhiu7MRgQ7wPdSHrv9sfU6xj8QPtZDs8zyYnI61J+p95AZuK36jJkAm7xI+
         Un6aGTf7x01SPojy0MAATsdsBebRrhBzNCgk+BHYUEBlJ8+y+ys+1SWnn3E/o1eR+hab
         fRxDTlr6S7cMk+F4r9Qe+go0P6PPzIhifTv3xA5BlV4zAlsjqP7RpTpDSDDWs1Q/JiwO
         LYMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=PTMzXA/YgDw0MB3J+5E7hzqxaAkfuwn6Ly5vzSypvxo=;
        b=n0Jh6/t20xR03gf2iw9LK01MsgiRkzDGfv/chXcVpoTL4+69pQowj/ojZKV4+iuAoW
         S1MkHjSSvNx8b7vZ8IhfUyRXxFR3eTLYUhDMFt8zhbj5KJ1YBYcI4vYlD+pMzl12e6+a
         xa7qUR621rP4QeEo6ULrvg/QbXw3dAqUa3bLDcKB8Z4RGUmbE0/lH4wM0u5NlT1RQ7mj
         OUHa5sYaXoHB+h7ziZffzxmYdiC0pc/iG5nzXODtLyjcQCqeIIcV7PQJ4xqoTlrPGtBn
         236Xs/NznkYgzjRnhCzRVp2de4zhRuhbZfN0dktTY82o2X6sApVQH9UkmPN080MFuT9y
         bETg==
X-Gm-Message-State: AOAM532QRob0R3EHmgSLq6b+xikHe6ugtD7U+UJpxTciy64tfuPxqh7Q
        arfHSL6jy4FZm/L9XIwhLrkdrNGqYyc=
X-Google-Smtp-Source: ABdhPJzkFXxDThrYEDomwoFJeOlHWQo+JlsSFyydOmR2VS+mmy6wSDoFMXup/5g2GrrC3oebBDC+6A==
X-Received: by 2002:a9d:7096:: with SMTP id l22mr2583375otj.79.1623407345433;
        Fri, 11 Jun 2021 03:29:05 -0700 (PDT)
Received: from smtpclient.apple ([2600:1700:9b91:a600:a072:c432:bb85:fd48])
        by smtp.gmail.com with ESMTPSA id u26sm1131440ote.53.2021.06.11.03.29.04
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Jun 2021 03:29:05 -0700 (PDT)
From:   Scott Fields <slfields66@gmail.com>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: "ip addr show" returns interface names that won't work with "ip addr
 show dev <ifname>"
Message-Id: <4DC83BAC-29D0-404E-8EA7-74B2BD80446C@gmail.com>
Date:   Fri, 11 Jun 2021 05:27:53 -0500
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=E2=80=9Cip addr show=E2=80=9D will return a list of devices that may =
not work with =E2=80=9Cip addr show dev <ifname>=E2=80=9D.

If you have list vlan device, it will return it as =E2=80=9C<vlan =
ifname>@<parent ifname>=E2=80=9D.

However, =E2=80=9Cip addr show dev <ifname>=E2=80=9D will not work with =
that name.

=E2=80=9Cip addr show dev <ifname>=E2=80=9D should work with interface =
names that =E2=80=9Cip addr show=E2=80=9D returns.=
