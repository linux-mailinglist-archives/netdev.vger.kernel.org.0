Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAD8C18E966
	for <lists+netdev@lfdr.de>; Sun, 22 Mar 2020 15:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgCVOix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Mar 2020 10:38:53 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39174 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbgCVOiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Mar 2020 10:38:52 -0400
Received: by mail-lj1-f195.google.com with SMTP id a2so11631945ljk.6
        for <netdev@vger.kernel.org>; Sun, 22 Mar 2020 07:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:in-reply-to:originaldate:originalfrom
         :original:date:from:to:cc:subject:message-id;
        bh=g4BO/O3DF8m2HwgtSn6CUsf7iPwwOjlw6LLp0F39/rs=;
        b=LKiGJxFOM3i9/cX/3zirJyEslWs2xh0mfuNuZ575yMfg2WsVknQIpxf/bOgoqJ2uJB
         vjILEtLbB+5i9Rv9I0yATozKSCdy+zAnIJgwiGzHu5cASq6ygZw9KWumbgyS0+BfOVdB
         11vJVeZ0y1APi4p+n1O/EGV+9FRdKHeNxrxBIHeCsbdCfWj05ck16By5hjoAdutENE7D
         ctwSNcIctXu+OHOugbWHsFQ1ArE6YfJKjnVGsPfkShrmJThjK8oC+I3VAw7SGVi3Stxs
         XoB9hnGgUwU2kWw09sKyLWprIjDkVLyteC7j72onXoV3RCmVX2u5fCePbkvSCrVQkpLy
         EMkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:in-reply-to
         :originaldate:originalfrom:original:date:from:to:cc:subject
         :message-id;
        bh=g4BO/O3DF8m2HwgtSn6CUsf7iPwwOjlw6LLp0F39/rs=;
        b=g1WXCPHypoAugPyZzU3LKeEgoTEMrqP+ow5aK1WFSmrLlVbpS0/6o8H2JlpKkQb6wq
         EQE3gCGMoeUIJ4MdxKQRKeYJY4JbyqWTOg/x5c5OvN6cyRpYchPvWXbqDKyC5lqmTtqU
         2lfq7gVMlPsa13ELbvEtC0nRl2lfJ5qmQECImtYP44C4gRNvcKyiIkakaaMk0eIesbEw
         riFFKUUUY6gb3YusqiOl+zK9axoF4K6EoZE8SpIV9ei/NaJdl2K6yEQy5G6KSz5n+cMi
         g3B1wSjyp7284Wk7HOtsLyR3hk/mkBVP0ZwX7uHugMfuMgzCp1inmshvd0PEqYS+fW0D
         Shhg==
X-Gm-Message-State: ANhLgQ0zIv9hEG/fS391yBqesfA6nV1UldGfdyi8Mpd/8Oag5mYr/pYx
        iWTahXZpIvMmgh6NZfVh4r22ag==
X-Google-Smtp-Source: ADFU+vugiUKsaQhxX96ctjwy3yFNeCoRai6rGsiF5uwkDQgIzI/RKK+ST6KgogEK42c7FIxuv7BW3w==
X-Received: by 2002:a2e:151e:: with SMTP id s30mr11303049ljd.92.1584887930182;
        Sun, 22 Mar 2020 07:38:50 -0700 (PDT)
Received: from localhost (h-50-180.A259.priv.bahnhof.se. [155.4.50.180])
        by smtp.gmail.com with ESMTPSA id m6sm4514030ljj.78.2020.03.22.07.38.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 22 Mar 2020 07:38:49 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <20200322133546.GD11481@lunn.ch>
Originaldate: Sun Mar 22, 2020 at 2:35 PM
Originalfrom: "Andrew Lunn" <andrew@lunn.ch>
Original: =?utf-8?q?On_Sat,_Mar_21,_2020_at_09:24:42PM_+0100,_Tobias_Waldekranz_wro?= =?utf-8?q?te:=0D=0A>_Describe_how_the_USB_to_MDIO_controller_can_optional?= =?utf-8?q?ly_use_device_tree=0D=0A>_bindings_to_reference_attached_device?= =?utf-8?q?s_such_as_switches.=0D=0A>_=0D=0A>_Signed-off-by:_Tobias_Waldek?= =?utf-8?q?ranz_<tobias@waldekranz.com>=0D=0A=0D=0AHi_Tobias=0D=0A=0D=0AA_?= =?utf-8?q?few_process_things.=0D=0A=0D=0AThe_subject_line_should_be_"[PAT?= =?utf-8?q?CH_net-next]_..."_to_indicate_which=0D=0Atree_this_is_for.=0D?= =?utf-8?q?=0A=0D=0AFor_a_patch_set,_please_always_include_a_cover_note._g?= =?utf-8?q?it_format-patch=0D=0Awill_generate_the_template_and_then_includ?= =?utf-8?q?e_text_about_the_patch=0D=0Aseries_as_a_whole.=0D=0A=0D=0Ahttps?= =?utf-8?q?://www.kernel.org/doc/Documentation/networking/netdev-FAQ.txt?= =?utf-8?q?=0D=0A=0D=0A=09Andrew=0D=0A?=
Date:   Sun, 22 Mar 2020 15:38:48 +0100
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Andrew Lunn" <andrew@lunn.ch>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] dt-bindings: net: add marvell usb to mdio
 bindings
Message-Id: <C1HFVR4KD34A.XPDBX1LM9SPV@wkz-x280>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun Mar 22, 2020 at 2:35 PM, Andrew Lunn wrote:
> The subject line should be "[PATCH net-next] ..." to indicate which
> tree this is for.

Right, my bad.

> For a patch set, please always include a cover note. git format-patch
> will generate the template and then include text about the patch
> series as a whole.

Roger that. Do you want a v4 with these changes, or just things to
keep in mind for the future?

Thank you for your patience
