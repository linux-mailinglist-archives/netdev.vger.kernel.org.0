Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00248DEF2A
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbfJUORm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:17:42 -0400
Received: from mail-pf1-f170.google.com ([209.85.210.170]:35547 "EHLO
        mail-pf1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728967AbfJUORl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:17:41 -0400
Received: by mail-pf1-f170.google.com with SMTP id 205so8527301pfw.2
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 07:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=FasvKT0tSPERrjUVjRI6scR+EB5VPqzibiGNqr1jZrE=;
        b=o80LURj4IIB6C29MqlhZeUmNAp77GI3NCAevLpC2O18TEGk2l5IQhJraa8jQdgQXI5
         kIK+OJuRyd5bQ2jRQIkPod4Cxq6sa8/FEki3PtJijWF7n13Aw5CWruvfmOWnmEdRANAz
         rZdVPSGYPk/PBWaBE/GPpKjJ8iVm26vrN6y9B1o2Bm/m0INEdGM1KnrvuPDHP+lpNw5R
         7JvPp5F7HwbMyt5slu7S5HwpczE93wgpvm6NS2fRPWXBwaSlJ4ZQVeRnA8YZO5ksAyzF
         /m+SG2h/rU+0XLgOuc23Q4c8xPArVtZEZddHvD7ULFlFjyFrh1P3/czIzIl+mkvuTKXC
         XSwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FasvKT0tSPERrjUVjRI6scR+EB5VPqzibiGNqr1jZrE=;
        b=eo5eVC8yn5bgm670qgFD7UP2Ncp+l+uMS2AE6Pv/J7wLuArF9sIw8ODOOwJO35ZN4l
         NErhc9Jk9mzfwMK89pMkgWgabgk3fydeJIv6pgM+VOYXtjbViKAz1Hz343ZLWEUwitxB
         5GEp5YMJxwETXo/R3/FpI0N5KPFVgoMlmv4SJDw9B/9lg48w8m8oOjOPKe2W7JCzItXO
         +JZMIkFec6OGvsY9NpWTQu9jhOJLIEv/5G0eD0b5FXtaOLa98Xnfx7wULJO6EEI7GgMA
         63AtOhNCqqo3HgO0ePTs+YMQ/WE+4MYQcFSpkH+sC98z6oqJ5aGdSKyKFyqg3w/zpALe
         ePJQ==
X-Gm-Message-State: APjAAAUkYO8Cpcr0+Fb3JFOHHSvqC5nZPv5b1YrorID7Ghx1/29BcSGS
        6fKO742PLl8DybZ/uzyMb/g=
X-Google-Smtp-Source: APXvYqxSeOdWjmB4Zd10hHdyvI8pjg2kHkcp+OOhpTQAes8iHSqexp7eYne/etcR4qjYIC1BvcjRrA==
X-Received: by 2002:a62:ab02:: with SMTP id p2mr23491135pff.92.1571667461156;
        Mon, 21 Oct 2019 07:17:41 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id o185sm21936371pfg.136.2019.10.21.07.17.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 07:17:40 -0700 (PDT)
Subject: Re: Crash when receiving FIN-ACK in TCP_FIN_WAIT1 state
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        netdev@vger.kernel.org, ycheng@google.com, eric.dumazet@gmail.com,
        ncardwell@google.com
References: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d09e2d5d-ccad-5add-59c5-a0d2058644e3@gmail.com>
Date:   Mon, 21 Oct 2019 07:17:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <68ad6fb82c0edfb788c7ce1a3bdc851b@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/20/19 1:25 PM, Subash Abhinov Kasiviswanathan wrote:
> We are seeing a crash in the TCP ACK codepath often in our regression
> racks with an ARM64 device with 4.19 based kernel.
> 

Please give us a pointer to the exact git tree and sha1.

I do not analyze TCP stack problems without an exact starting point,
or at least a crystal ball, which I do not have.
