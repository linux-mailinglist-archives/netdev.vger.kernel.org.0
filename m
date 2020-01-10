Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA5871366FE
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 06:58:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgAJF6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 00:58:36 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36910 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726655AbgAJF6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 00:58:35 -0500
Received: by mail-lf1-f68.google.com with SMTP id b15so550702lfc.4;
        Thu, 09 Jan 2020 21:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9/biCTbC8LKG8zYr7+EdqUKI7EhxsYz+bm1dnOsqaXI=;
        b=a7023Fik5kBbUvqd/uPGP9skc+DwiwYdaJaURf+ltrA24mJ15ljoHLa74I5X9dmSG/
         U0kvkLKItqtFXmZwHNa5Q/A/W7C20fugDVxDJrkb4EWwZ5Mnit86kXKm9jAVPPhlmBoN
         Ij6jJOUxKbbU4rWqeaXIYRUL7De6zF3zoEur26fIZg2KAPuc0EDuSLhLAFzw8U/RVFn7
         IZJ/TvdkIkljc7e9skIdV76CFyBg4IKFtIgRTQbwhEwV0z25lWvnZr6s0J1Tcek0+uS+
         cHLcD/edWoXML+TMlwqYW4h2XT9gqkRynQiEVTAmtETuINId4K03PFCNsJj5ORazXMc6
         0yxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9/biCTbC8LKG8zYr7+EdqUKI7EhxsYz+bm1dnOsqaXI=;
        b=mXyUuCfVUuEWA/GEYi4aGXgiUpCw4nF1rBDPqblgg+TgUVXjaWCzI4GA50TnN12U3x
         +OIm4tDUOEqyRzKJdHE+DhtJyGRBInSYaT/sJvC7OxmWuyifJIkE/E3j3A9H30piAm2A
         rblPw3DdT8sdWWlmrNlcta7jJXkQFYbY8sJbmMLR+/X30VgTAbWmb7hG5S8FoZ6Q8SgM
         2pqhNld2yY6o1moPkya6US87akIRXd/G5+ZPREISFyng1rQvWAU2tnHGIUdFusz4PEVD
         QGrGnCEWcCzNj3K9/EQUQ8XPMCS+fisnhNzcS8KTYtbh8XcT4W32U1kSpBcHDBNQ+HLV
         VYLw==
X-Gm-Message-State: APjAAAVh6webkykmH84XI7bWNrbzb8jBv3MFZAJZpqve6ocqDt6Q25YI
        6gi2FWMYu2H98okBeQ58MXdHIncZhciAKLgATPG6jQ==
X-Google-Smtp-Source: APXvYqxlu/4541DP62CC+z7dm/AEH6FQDqZhrkpKvn4SGu3rPyxRhC+F9LJGcNzpFS833YLg/ln4NF1UhAlrL3sfWJk=
X-Received: by 2002:a19:6d13:: with SMTP id i19mr1082657lfc.6.1578635913928;
 Thu, 09 Jan 2020 21:58:33 -0800 (PST)
MIME-Version: 1.0
References: <20200110051716.1591485-1-andriin@fb.com>
In-Reply-To: <20200110051716.1591485-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 9 Jan 2020 21:58:22 -0800
Message-ID: <CAADnVQ+AtbJ1M-Fss5WocSP=EmKgyZrCYUN8NtOFSx5DeYf2gg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] Fix usage of bpf_helper_defs.h in selftests/bpf
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 9, 2020 at 9:17 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Fix issues with bpf_helper_defs.h usage in selftests/bpf. As part of that, fix
> the way clean up is performed for libbpf and selftests/bpf. Some for Makefile
> output clean ups as well.

feature auto-detect and few unnecessary installs are now
happening even when make shouldn't be doing anything.
But overall it's still an improvement.
Applied. Thanks
