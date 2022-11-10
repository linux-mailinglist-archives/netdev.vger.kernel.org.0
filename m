Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87E9C623CED
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 08:51:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232651AbiKJHvt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 02:51:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbiKJHvs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 02:51:48 -0500
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B0913D4B
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 23:51:47 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-13bef14ea06so1388066fac.3
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 23:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=imDmy6IY9lWbEJZ/7NC1MP82R93/j01/DT3lv1iCmmo=;
        b=KQz1iLrKyGTd2y/XoGDNw2s82w7rpmgDWeI4ioTRs2F8FZ2mwAhHD1XsGv/YPE23Tw
         a6QaEDj1YdZKb5wCBDEv/4X/eDuOsON/p8i+QvjxSgrYUvQueXUPV7gzZWnxMYplS7Qd
         7Q+lelnrUWYJ8oAdLvdzMawAkUvCjoVTDPQnrz1iylrc7lUSR8NIP5LmeLikXjpV1xsr
         mcuASzrnZiP1/up+r+AQ4HZP224rm6bglLXwttkEAZ1EHplPDkH40GmNTHr460xEM2oT
         di1RX0Pn+2jCoBWLinN2Gf+xxeyjcRloyjTrCwvJ+wjNJTmPEgxeVNLqPFqyYv84vu/8
         TafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=imDmy6IY9lWbEJZ/7NC1MP82R93/j01/DT3lv1iCmmo=;
        b=Swho/VqjF88T9lSyeK9K+Tuyt3XtNVwH1HUTRcRErxlTUyTEPjN+aON5leGH/MVQfM
         0qbw/IR4wfio92leG4H1H1rbe1BoSjnqMHVJFg/j+TRyNVnQGGZQuxmt6swVszqYodJ0
         drp3LpVnkxhtoU1Ia/LehC4GGmwoePBqDm5UjJjtk/zxwpd+xjfzAi6vC2ICvIy+2bGi
         Tqjyvv618uPvedfWuz3G8uNzFuofbDjMCeFI2vVL4ThoQM+1W9aohBhTZKqG2PSsI4DW
         mYAjXLQUfKYYlSBN5HX0SxFbnYo8cXBvhAevarQWXRKKT/Aasx/tmpEIYzBSOfB8dHjb
         p45g==
X-Gm-Message-State: ACrzQf1a5xRR8V0pAxxcB86xxWnqdSEEmXxUtkB7xd1RHoLejehl5r/7
        4BWafUZJsMaAk8Gr01IO2Oz2ju1CzA3oyWRJNdcGTgdYWPM=
X-Google-Smtp-Source: AMsMyM7D0caYR5Qrbs9hwOgw0q55kCz2iY1MANh7ZU+yHz2izKjZOl6mB9SH2J+8FFx5YuNtEODlY9fWelHOfQBij8U=
X-Received: by 2002:a05:6871:438c:b0:13b:8b3e:3048 with SMTP id
 lv12-20020a056871438c00b0013b8b3e3048mr1205748oab.273.1668066706001; Wed, 09
 Nov 2022 23:51:46 -0800 (PST)
MIME-Version: 1.0
From:   Leonid Komaryanskiy <lkomaryanskiy@gmail.com>
Date:   Thu, 10 Nov 2022 09:51:35 +0200
Message-ID: <CAHRDKfRZEw3Mq9GP3rCf2U10Y7X7N61BNZCa95tKESZkVD2qAg@mail.gmail.com>
Subject: ip_forward notification for driver
To:     netdev@vger.kernel.org
Cc:     dmytro_firsov@epam.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

I'm working on L3 routing offload for switch device and have a
question about ip_forwarding. I want to disable/enable forwarding on
the hardware side according to changing value in
/proc/sys/net/ipv4/ip_forward. As I see, inet_netconf_notify_devconf
just sends rtnl_notify for userspace. Could I ask you for advice, on
how can I handle updating value via some notifier or some other Linux
mechanism in driver?

Thank you in advance.

Kind Regards, Leonid.
