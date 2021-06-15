Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE833A7C08
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 12:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhFOKgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 06:36:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49510 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231422AbhFOKgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 06:36:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623753252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PM/+4yLdlWLHqPG09fjdGm9pa7Y05Js4VwOnFs9aPQ4=;
        b=YxgCSLn5cQL0bTNQTZlFWtgZwigcxr1rpbEcquYDYbtRV5QIjGPDo4u+8tLvekc4sOawi6
        v6NsEedvPVuUfWGUm9hGQVrMEH66Wsv/aoVxs3Nxw+PoK65ngOhXu27pJ5JHU9Ww2ykrHT
        fhpWE3MkHavnuQH6KzeWaVZLz0OG3iE=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-539-wr7bgct-NNyI9yvnZlLIvA-1; Tue, 15 Jun 2021 06:34:11 -0400
X-MC-Unique: wr7bgct-NNyI9yvnZlLIvA-1
Received: by mail-io1-f70.google.com with SMTP id e23-20020a6bf1170000b02904d7ff72e203so1054921iog.0
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 03:34:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=PM/+4yLdlWLHqPG09fjdGm9pa7Y05Js4VwOnFs9aPQ4=;
        b=HoHtlijgcl47mdrhd3WehKVpj9LPy79NQwBESAdoc7GRPdH/c2nHSQMSRMUBPPKz0D
         voWsGUjTYCXgJtms9TNdHZjLqNwq3Z03n/uoCy1gCOyBpNIeY4OQCMezR7y7bb1j11yn
         cv09d9DlOTdT6YC48eCAXZBW3QzJv2aN+PppsKodlxaZi32gn4SE8kv24HS41x2g3Qvz
         QUK4UwlQH6Rt7t3C8JC9j09+rgoi81lGEUaT8l1mpiO/rUFaL7nPDxdkbdhNMFtGV4OO
         dKNxyND+SX/2rsAkQXSdFutQOau2Tp91X1LKub2dBK0HpWK6yjhg5fvKBuYmyyqFir+d
         lvLA==
X-Gm-Message-State: AOAM530N9Bfk/OcbqebDlOXCwS8bl7lbU/gV/zXbrT33ET99shxa+1m9
        Y8YX/pD+8wnRS50QRTIQoo9RncAhJVSon4AmyaqZd93jHwNwGzRyVd8+R/z2v02H6D8Vnj0+iGp
        ioH7hxit7ei+cPu3u1vJJz4Ej+QREIBbm
X-Received: by 2002:a05:6e02:1d03:: with SMTP id i3mr17490034ila.35.1623753250811;
        Tue, 15 Jun 2021 03:34:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIbZZMZvLhVoy6oqXLmcIkSFM1/uIJE1lXkLsBOdrMFKWD8fcyLODkbNBhf1jxUjS1tpxDf1h9lzfvpzvmxN0=
X-Received: by 2002:a05:6e02:1d03:: with SMTP id i3mr17490025ila.35.1623753250658;
 Tue, 15 Jun 2021 03:34:10 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Tue, 15 Jun 2021 12:34:00 +0200
Message-ID: <CACT4oueyNoQAVW1FDcS_aus9sUqNvJhj87e_kUEkzz3azm2+pQ@mail.gmail.com>
Subject: Correct interpretation of VF link-state=auto
To:     netdev@vger.kernel.org
Cc:     Ivan Vecera <ivecera@redhat.com>,
        Edward Harold Cree <ecree@xilinx.com>,
        Dinan Gunawardena <dinang@xilinx.com>,
        Pablo Cascon <pabloc@xilinx.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Regarding link-state attribute for a VF, 'man ip-link' says:
state auto|enable|disable - set the virtual link state as seen by the
specified VF. Setting to auto means a reflection of the PF link state,
enable lets the VF to communicate with other VFs on this host even if
the PF link state is down, disable causes the HW to drop any packets
sent by the VF.

However, I've seen that different interpretations are made about that
explanation, especially about "auto" configuration. It is not clear if
it should follow PF "physical link status" or PF "administrative link
status". With the latter, `ip set PF down` would put the VF down too,
but with the former you'd have to disconnect the physical port.

Thanks
--=20
=C3=8D=C3=B1igo Huguet

